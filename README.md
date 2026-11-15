# Presyo ng Bigas - setup (all free)

**Public site:** `https://YOURSITE.pages.dev/`  (read-only for everyone)
**Admin site:** `https://YOURSITE.pages.dev/admin`  (sign-in required; can add, edit, delete anything)

## 1. Database (Supabase, free)
1. Create a project at supabase.com.
2. SQL Editor > paste all of `schema.sql` > Run. This creates the tables, the 17 PH regions, rice varieties, and the read-only / admin-only rules.
3. Authentication > Users > **Add user** (your email + password, tick "auto confirm").
4. Authentication > Sign In / Providers > turn **off** "Allow new users to sign up".
5. SQL Editor, run: `insert into admins select id from auth.users where email = 'you@example.com';`
6. Project Settings > API: copy the Project URL and the **anon public** key into `config.js`. Never use the service_role key.

## 2. Launch (Cloudflare Pages, free)
1. Put these files in a GitHub repo.
2. Cloudflare dashboard > Workers & Pages > Create > Pages > connect the repo. Build command: none. Output directory: `/`.
3. You get a live `*.pages.dev` URL. Admin is that URL + `/admin`.

## How access is enforced
Visitors use the public key, which the database only lets **read**. Writes require a signed-in user listed in the `admins` table, so hiding the admin URL is not what protects you; the database rules are. Optional extra: protect `/admin` with Cloudflare Access (free for up to 50 users).

## Keep it alive
Supabase pauses free projects after ~1 week of no activity. Visit the site weekly or add a scheduled GitHub Action that requests it.

## Where to get Philippine rice prices
Check the PSA (psa.gov.ph) price releases and the DA Bantay Presyo site. Confirm each site's terms before copying or scraping data, and record the source in each entry.
