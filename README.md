# Bambikowa Liga Typerow

Prywatna liga typerow na Vercel + Supabase.

## Vercel

Ustaw zmienne srodowiskowe:

```text
SUPABASE_URL=https://twoj-projekt.supabase.co
SUPABASE_ANON_KEY=twoj-publiczny-anon-lub-publishable-key
```

## Supabase

1. Uruchom `supabase/schema.sql` w SQL Editor.
2. Zamien placeholdery maili w `league_invites` na prawdziwe adresy graczy.
3. Wgraj terminarz do tabeli `matches`.

Nie ustawiaj w frontendzie ani w publicznych zmiennych `service_role`.
