-- FIFA World Cup 2026 schedule corrections for Bambikowa Liga Typerow.
-- Source of truth: official FIFA match schedule page.
-- Run this after the original seed if the database already contains the 104 matches.

UPDATE public.matches AS m
SET
  stage = v.stage,
  team_a = v.team_a,
  team_b = v.team_b,
  venue = v.venue,
  flag_a_code = v.flag_a_code,
  flag_b_code = v.flag_b_code,
  kickoff_at = v.kickoff_at::timestamptz,
  match_day = v.match_day::date,
  is_knockout = v.is_knockout
FROM (VALUES
  (31, 'Grupa C', 'Brazylia', 'Haiti', 'Foxborough, USA', 'br', 'ht', '2026-06-20T03:00:00+02:00', '2026-06-20', false),
  (32, 'Grupa D', 'Turcja', 'Paragwaj', 'Santa Clara, USA', 'tr', 'py', '2026-06-20T06:00:00+02:00', '2026-06-20', false),
  (51, 'Grupa C', 'Szkocja', 'Brazylia', 'Miami, USA', 'gb-sct', 'br', '2026-06-25T00:00:00+02:00', '2026-06-25', false),
  (52, 'Grupa C', 'Maroko', 'Haiti', 'Atlanta, USA', 'ma', 'ht', '2026-06-25T00:00:00+02:00', '2026-06-25', false),
  (53, 'Grupa A', 'Czechy', 'Meksyk', 'Mexico City, Mexico', 'cz', 'mx', '2026-06-25T03:00:00+02:00', '2026-06-25', false),
  (54, 'Grupa A', 'RPA', 'Korea Południowa', 'Guadalupe, Mexico', 'za', 'kr', '2026-06-25T03:00:00+02:00', '2026-06-25', false),
  (57, 'Grupa F', 'Japonia', 'Szwecja', 'Arlington, USA', 'jp', 'se', '2026-06-26T01:00:00+02:00', '2026-06-26', false),
  (58, 'Grupa F', 'Tunezja', 'Holandia', 'Kansas City, USA', 'tn', 'nl', '2026-06-26T01:00:00+02:00', '2026-06-26', false),
  (65, 'Grupa G', 'Egipt', 'Iran', 'Seattle, USA', 'eg', 'ir', '2026-06-27T05:00:00+02:00', '2026-06-27', false),
  (66, 'Grupa G', 'Nowa Zelandia', 'Belgia', 'Vancouver, Canada', 'nz', 'be', '2026-06-27T05:00:00+02:00', '2026-06-27', false),
  (74, '1/16 finału', '1E', '3A/B/C/D/F', 'Foxborough, USA', NULL, NULL, '2026-06-29T22:30:00+02:00', '2026-06-29', true),
  (75, '1/16 finału', '1F', '2C', 'Guadalupe, Mexico', NULL, NULL, '2026-06-30T03:00:00+02:00', '2026-06-30', true),
  (76, '1/16 finału', '1C', '2F', 'Houston, USA', NULL, NULL, '2026-06-29T19:00:00+02:00', '2026-06-29', true),
  (77, '1/16 finału', '1I', '3C/D/F/G/H', 'New Jersey, USA', NULL, NULL, '2026-06-30T23:00:00+02:00', '2026-06-30', true),
  (78, '1/16 finału', '2E', '2I', 'Arlington, USA', NULL, NULL, '2026-06-30T19:00:00+02:00', '2026-06-30', true),
  (81, '1/16 finału', '1D', '3B/E/F/I/J', 'Santa Clara, USA', NULL, NULL, '2026-07-02T02:00:00+02:00', '2026-07-02', true),
  (82, '1/16 finału', '1G', '3A/E/H/I/J', 'Seattle, USA', NULL, NULL, '2026-07-01T22:00:00+02:00', '2026-07-01', true),
  (83, '1/16 finału', '2K', '2L', 'Toronto, Canada', NULL, NULL, '2026-07-03T01:00:00+02:00', '2026-07-03', true),
  (84, '1/16 finału', '1H', '2J', 'Los Angeles, USA', NULL, NULL, '2026-07-02T21:00:00+02:00', '2026-07-02', true),
  (86, '1/16 finału', '1J', '2H', 'Miami, USA', NULL, NULL, '2026-07-04T00:00:00+02:00', '2026-07-04', true),
  (87, '1/16 finału', '1K', '3D/E/I/J/L', 'Kansas City, USA', NULL, NULL, '2026-07-04T03:30:00+02:00', '2026-07-04', true),
  (88, '1/16 finału', '2D', '2G', 'Arlington, USA', NULL, NULL, '2026-07-03T20:00:00+02:00', '2026-07-03', true),
  (89, '1/8 finału', 'Zwycięzca meczu 74', 'Zwycięzca meczu 77', 'Philadelphia, USA', NULL, NULL, '2026-07-04T23:00:00+02:00', '2026-07-04', true),
  (90, '1/8 finału', 'Zwycięzca meczu 73', 'Zwycięzca meczu 75', 'Houston, USA', NULL, NULL, '2026-07-04T19:00:00+02:00', '2026-07-04', true)
) AS v(id, stage, team_a, team_b, venue, flag_a_code, flag_b_code, kickoff_at, match_day, is_knockout)
WHERE m.id = v.id;
