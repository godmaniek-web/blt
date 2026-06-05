# Supabase setup

1. Uruchom `schema.sql` w SQL Editor.
2. Zamien placeholdery maili w `league_invites` na prawdziwe maile graczy.
3. Uruchom seed terminarza z lokalnego pliku przygotowanego przez Codexa: `outputs/supabase-seed-matches.sql` albo `outputs/bambikowa-vercel-static/supabase/seed-matches.sql`.
4. W Authentication wlacz magic link e-mail.
5. W URL configuration dodaj adres z Vercel jako redirect URL.

Uwaga: `service_role` nigdy nie trafia do frontendu ani do publicznych zmiennych Vercel.
