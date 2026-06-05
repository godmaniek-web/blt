-- Bambikowa Liga Typerow - simple PIN schema
-- This replaces the email-auth version. Run in Supabase SQL Editor.
-- Access is gated in the app with PIN 2020. This is simple, not high-security.

drop table if exists public.results cascade;
drop table if exists public.predictions cascade;
drop table if exists public.profiles cascade;
drop table if exists public.league_invites cascade;

create table public.profiles (
  display_name text primary key,
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

create table public.predictions (
  player_name text not null references public.profiles(display_name) on delete cascade,
  match_id integer not null references public.matches(id) on delete cascade,
  goals_a integer not null check (goals_a >= 0),
  goals_b integer not null check (goals_b >= 0),
  winner text,
  updated_at timestamptz not null default now(),
  primary key (player_name, match_id)
);

create table public.results (
  match_id integer primary key references public.matches(id) on delete cascade,
  goals_a integer not null check (goals_a >= 0),
  goals_b integer not null check (goals_b >= 0),
  winner text,
  updated_at timestamptz not null default now()
);

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

alter table public.profiles enable row level security;
alter table public.matches enable row level security;
alter table public.predictions enable row level security;
alter table public.results enable row level security;

drop policy if exists "anon read profiles" on public.profiles;
create policy "anon read profiles" on public.profiles for select to anon using (true);

drop policy if exists "anon read matches" on public.matches;
create policy "anon read matches" on public.matches for select to anon using (true);

drop policy if exists "anon read predictions" on public.predictions;
create policy "anon read predictions" on public.predictions for select to anon using (true);

drop policy if exists "anon insert predictions" on public.predictions;
create policy "anon insert predictions" on public.predictions for insert to anon with check (true);

drop policy if exists "anon update predictions" on public.predictions;
create policy "anon update predictions" on public.predictions for update to anon using (true) with check (true);

drop policy if exists "anon read results" on public.results;
create policy "anon read results" on public.results for select to anon using (true);

drop policy if exists "anon insert results" on public.results;
create policy "anon insert results" on public.results for insert to anon with check (true);

drop policy if exists "anon update results" on public.results;
create policy "anon update results" on public.results for update to anon using (true) with check (true);

drop policy if exists "anon delete results" on public.results;
create policy "anon delete results" on public.results for delete to anon using (true);

insert into public.profiles (display_name, is_admin) values
  ('Helsi', true),
  ('Luszyn', false),
  ('Arturito', false),
  ('Gadula', false),
  ('Naf', false),
  ('Nader', false),
  ('Robson', false)
on conflict (display_name) do update set is_admin = excluded.is_admin;
