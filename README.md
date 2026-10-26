# Two Edits Shop

A mobile app for running the Two Edits boutique: record sales, track stock by size, add product photos, and see daily, weekly and monthly reports.

| Part | What it does | Cost |
|---|---|---|
| **GitHub** | Stores all the project files and their history | Free |
| **Supabase** | The database (products, sales) and photo storage | Free plan |
| **Netlify** | Hosts the app at your own web link and updates it automatically from GitHub | Free plan |

## What’s in this project

```
two-edits/
├── public/                  ← the app itself (this is what Netlify publishes)
│   ├── index.html           ← page layout
│   ├── css/styles.css       ← colours, fonts, spacing
│   ├── js/app.js            ← how the app works
│   ├── js/config.js         ← your Supabase URL and key (edit this)
│   ├── manifest.webmanifest ← lets the phone install it like an app
│   └── sw.js                ← lets the app open without internet
├── supabase/
│   ├── 01-setup.sql         ← creates the database and loads your stock (new projects)
│   ├── 02-add-photos.sql    ← only for projects set up before photos existed
│   ├── 03-open-without-login.sql ← removes the sign-in screen
│   └── 04-require-login-again.sql ← optional: undo 03
├── netlify.toml             ← Netlify settings
└── README.md                ← this guide
```

The `supabase` folder is **not** published on your website. Only the `public` folder is.

---

## Setup, step by step

Do these in order. It takes about 30 minutes the first time.

### Step 1: Supabase (the database)

If you already set up Supabase earlier and ran `setup.sql` and `update-photos.sql`, skip to **1.4**.

1. **Create the project.** Go to [supabase.com](https://supabase.com), sign in, and click **New project**. Name it `two-edits`, choose the **Mumbai** region, and set a database password (save it somewhere).
2. **Create the tables and load your stock.** Open **SQL Editor → New query**. Paste everything from `supabase/01-setup.sql` and click **Run**. It should say *Success*.
3. **Let the app open without a login.** In **SQL Editor → New query**, paste everything from `supabase/03-open-without-login.sql` and click **Run**. The app then opens straight to your shop, with no sign-in screen.
4. **Copy your keys.** Open **Project Settings → API**. Copy the **Project URL** and the **anon / publishable key**.

### Step 2: Put your keys in the app

Open `public/js/config.js` and paste your two values between the quotes:

```js
window.TWO_EDITS_CONFIG = {
  supabaseUrl: 'https://abcdefgh.supabase.co',
  supabaseAnonKey: 'eyJhbGciOi...'
};
```

### Step 3: GitHub (store the files)

1. Sign in at [github.com](https://github.com) and click **New repository**.
2. Name it `two-edits` and choose **Private**. Private matters, because `01-setup.sql` contains your cost prices.
3. Tick nothing else and click **Create repository**.
4. On the next page, click **uploading an existing file**. Drag in **everything inside** the `two-edits` folder: `public`, `supabase`, `netlify.toml`, `README.md` and `.gitignore`.
   - `.gitignore` is a hidden file. On a Mac, press `Cmd + Shift + .` to see it. If you can’t find it, skip it; it’s not essential.
5. Click **Commit changes**.

Check the result: the top level of the repository should show the `public` and `supabase` folders and `netlify.toml`, not a single `two-edits` folder.

### Step 4: Netlify (put the app online)

1. Sign in at [netlify.com](https://app.netlify.com) **with your GitHub account**.
2. Click **Add new site → Import an existing project → GitHub**. Allow Netlify to see your `two-edits` repository and select it.
3. Netlify reads `netlify.toml` by itself. Leave the build command empty, and check that the publish directory shows `public`.
4. Click **Deploy**. After about a minute you get a link like `random-name.netlify.app`.
5. To rename it, go to **Site configuration → Change site name**, for example `twoedits` → `twoedits.netlify.app`.

If you made a Netlify site earlier by dragging a folder in, you can delete that old site now, or keep using it and connect it to GitHub under **Site configuration → Build & deploy → Link repository**.

### Step 5: Install on your phone

1. Open your Netlify link in **Chrome** (Android) or **Safari** (iPhone).
2. Add it to your home screen:
   - Android: ⋮ → **Add to Home screen** (or **Install app**)
   - iPhone: Share → **Add to Home Screen**

---

## Making changes later

Every change you save on GitHub goes live automatically within about a minute.

1. Open the file on github.com, for example `public/js/config.js`.
2. Click the pencil icon ✏️, make the change, and click **Commit changes**.
3. Netlify notices and republishes. You can watch it under **Deploys** in Netlify.

If you ever change the database (new tables or columns), put the SQL in a new numbered file in `supabase/` (for example `03-…sql`) and run it in the Supabase SQL Editor. That way GitHub keeps a record of every database change.

## Using the app

- **Sell:** search a product and tap the size that sold. You can change the price for discounts, pick Cash, UPI or Card, and record the sale.
- **Stock:** shows what’s on the rail by size. Tap a product to edit it, update counts, or add a photo. Use **+ Add product** for new purchases.
- **Sales:** your daily list of sales. Deleting a wrong sale puts the piece back into stock.
- **Report:** sales, profit, which sizes sell, supplier performance, best sellers, and backup downloads.

Sales recorded without internet are kept on the phone and sync automatically when you’re back online.

## Keeping things safe and running

- **Backups:** once a month, go to Report → **Download full backup** and save the file to Google Drive.
- **Supabase free plan:** the project pauses after 7 days with no activity. Daily use keeps it awake. If it pauses, click **Restore** in the Supabase dashboard.
- **Who can see your data:** anyone who has your app link. Share it only with your staff. If the link ever leaks, change the site name in Netlify (Site configuration → Change site name) so the old link stops working.
- **More staff:** just send them the link.
- **Photos:** product photos are stored in Supabase’s `shop` storage folder. Anyone who has a photo’s exact link can view it, but they can’t list, add or delete photos.
