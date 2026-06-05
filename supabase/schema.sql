create table if not exists public.league_invites (
  email text primary key,
  display_name text not null unique,
  is_admin boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null unique,
  email text not null unique,
  is_admin boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.matches (
  id integer primary key,
  stage text not null,
  team_a text not null,
  team_b text not null,
  venue text,
  flag_a_code text,
  flag_b_code text,
  kickoff_at timestamptz not null,
  match_day date not null,
  is_knockout boolean not null default false
);

create table if not exists public.predictions (
  user_id uuid not null references public.profiles(id) on delete cascade,
  match_id integer not null references public.matches(id) on delete cascade,
  goals_a integer not null check (goals_a >= 0),
  goals_b integer not null check (goals_b >= 0),
  winner text,
  updated_at timestamptz not null default now(),
  primary key (user_id, match_id)
);

create table if not exists public.results (
  match_id integer primary key references public.matches(id) on delete cascade,
  goals_a integer not null check (goals_a >= 0),
  goals_b integer not null check (goals_b >= 0),
  winner text,
  updated_by uuid references public.profiles(id),
  updated_at timestamptz not null default now()
);

create schema if not exists private;

create or replace function private.is_league_member(user_id uuid)
returns boolean language sql security definer set search_path = public as $$
  select exists (select 1 from public.profiles p where p.id = user_id);
$$;

create or replace function private.is_league_admin(user_id uuid)
returns boolean language sql security definer set search_path = public as $$
  select exists (select 1 from public.profiles p where p.id = user_id and p.is_admin = true);
$$;

create or replace function private.create_profile_for_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, display_name, email, is_admin)
  select new.id, i.display_name, lower(new.email), i.is_admin
  from public.league_invites i
  where lower(i.email) = lower(new.email)
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists create_profile_for_new_user on auth.users;
create trigger create_profile_for_new_user after insert on auth.users
for each row execute function private.create_profile_for_new_user();

create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists predictions_touch_updated_at on public.predictions;
create trigger predictions_touch_updated_at before update on public.predictions
for each row execute function public.touch_updated_at();

drop trigger if exists results_touch_updated_at on public.results;
create trigger results_touch_updated_at before update on public.results
for each row execute function public.touch_updated_at();

alter table public.league_invites enable row level security;
alter table public.profiles enable row level security;
alter table public.matches enable row level security;
alter table public.predictions enable row level security;
alter table public.results enable row level security;

drop policy if exists "profiles visible to members" on public.profiles;
create policy "profiles visible to members" on public.profiles for select to authenticated
using (private.is_league_member(auth.uid()));

drop policy if exists "matches visible to members" on public.matches;
create policy "matches visible to members" on public.matches for select to authenticated
using (private.is_league_member(auth.uid()));

drop policy if exists "own or locked predictions visible" on public.predictions;
create policy "own or locked predictions visible" on public.predictions for select to authenticated
using (
  private.is_league_member(auth.uid()) and (
    user_id = auth.uid() or exists (
      select 1 from public.matches m
      where m.id = predictions.match_id and now() >= m.kickoff_at - interval '15 minutes'
    )
  )
);

drop policy if exists "insert own predictions before lock" on public.predictions;
create policy "insert own predictions before lock" on public.predictions for insert to authenticated
with check (
  private.is_league_member(auth.uid()) and user_id = auth.uid()
  and exists (select 1 from public.matches m where m.id = predictions.match_id and now() < m.kickoff_at - interval '15 minutes')
);

drop policy if exists "update own predictions before lock" on public.predictions;
create policy "update own predictions before lock" on public.predictions for update to authenticated
using (
  private.is_league_member(auth.uid()) and user_id = auth.uid()
  and exists (select 1 from public.matches m where m.id = predictions.match_id and now() < m.kickoff_at - interval '15 minutes')
)
with check (
  private.is_league_member(auth.uid()) and user_id = auth.uid()
  and exists (select 1 from public.matches m where m.id = predictions.match_id and now() < m.kickoff_at - interval '15 minutes')
);

drop policy if exists "results visible to members" on public.results;
create policy "results visible to members" on public.results for select to authenticated
using (private.is_league_member(auth.uid()));

drop policy if exists "admins insert results" on public.results;
create policy "admins insert results" on public.results for insert to authenticated
with check (private.is_league_admin(auth.uid()));

drop policy if exists "admins update results" on public.results;
create policy "admins update results" on public.results for update to authenticated
using (private.is_league_admin(auth.uid())) with check (private.is_league_admin(auth.uid()));

drop policy if exists "admins delete results" on public.results;
create policy "admins delete results" on public.results for delete to authenticated
using (private.is_league_admin(auth.uid()));

insert into public.league_invites (email, display_name, is_admin) values
  ('helsi@example.com', 'Helsi', true),
  ('luszyn@example.com', 'Luszyn', false),
  ('arturito@example.com', 'Arturito', false),
  ('gadula@example.com', 'Gadula', false),
  ('naf@example.com', 'Naf', false),
  ('nader@example.com', 'Nader', false),
  ('robson@example.com', 'Robson', false)
on conflict (email) do update set display_name = excluded.display_name, is_admin = excluded.is_admin;

insert into public.profiles (id, display_name, email, is_admin)
select u.id, i.display_name, lower(u.email), i.is_admin
from auth.users u join public.league_invites i on lower(i.email) = lower(u.email)
on conflict (id) do nothing;
