# Bambikowa Liga Typerow

Prywatna liga typerow na Vercel + Supabase.

## Logowanie

Strona uzywa prostego PIN-u:

```text
2020
```

Po wpisaniu PIN-u gracz wybiera swoja nazwe z listy i moze typowac.

## Vercel

Ustaw zmienne srodowiskowe:

```text
SUPABASE_URL=https://twoj-projekt.supabase.co
SUPABASE_ANON_KEY=twoj-publiczny-anon-lub-publishable-key
```

Nie uzywaj `service_role`.

## Supabase

1. Uruchom `supabase/schema.sql` w SQL Editor.
2. Uruchom seed terminarza z lokalnego pliku przygotowanego przez Codexa: `outputs/supabase-seed-matches.sql` albo `outputs/bambikowa-vercel-static/supabase/seed-matches.sql`.

Uwaga: ten wariant jest prosty i wygodny dla prywatnej ligi znajomych. PIN w frontendzie nie jest mocnym zabezpieczeniem.
