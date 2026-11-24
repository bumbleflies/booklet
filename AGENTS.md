# AGENTS.md

## What this repo is

A tiny, flat repo that turns Canva-exported PDFs of a square, 28-page booklet into
print-ready PDFs. There is no application source, package manager, or test suite —
just two shell scripts, two checked-in source PDFs, and GitHub Actions workflows.

## Layout

- `booklet_no_bleed.pdf` — Canva export used for the home-print layout. Treat as an input.
- `booklet_with_bleed.pdf` — Canva export used for the professional-print layout. Treat as an input.
- `canva_to_home_print.sh <input.pdf> <output.pdf>` — splits pages with `mutool poster -x 2`, then imposes them with `pdfjam` at 148 × 148 mm.
- `canva_to_professional_print.sh <input.pdf> <output.pdf>` — crops left/right halves with `pdfcrop`, then imposes at 154 × 154 mm (148 mm content).
- `.github/workflows/booklet.yml` — builds both variants on push and PR to `master`, uploads artifact `booklet-pdfs`, and on push only publishes `out/` to the `release` branch.
- `.github/workflows/release.yml` — on `v*` tags, publishes the professional-print PDF from `release` as a GitHub Release.

`README.md` still references `create_from_canva.sh`, which is not in this repo. Use
the two scripts listed above.

## Build / verify

Prerequisites are the packages CI installs: `mupdf-tools` (`mutool`),
`texlive-extra-utils` (`pdfjam`, `pdfcrop`), `texlive-latex-recommended`, and
`texlive-latex-base`. On Debian/Ubuntu:

```bash
sudo apt install mupdf-tools texlive-extra-utils texlive-latex-recommended texlive-latex-base
```

Generate both print variants locally:

```bash
mkdir -p out
./canva_to_home_print.sh booklet_no_bleed.pdf out/booklet_home_print.pdf
./canva_to_professional_print.sh booklet_with_bleed.pdf out/booklet_professional_print.pdf
```

There are no automated tests. Verification is that both scripts exit 0, the output
PDFs are created in `out/`, and the imposed page order and paper size are correct
(148 mm square for home print, 154 mm square for professional print). CI runs the
same build on every push and PR to `master` — check that workflow for a definitive result.

## Conventions and safety

- Do not commit generated PDFs or `out/`. Those are build artifacts owned by CI and
  published to the `release` branch, not source for `master`.
- Replace the checked-in `booklet_*.pdf` inputs only with a deliberate new Canva
  export, and regenerate both variants afterwards.
- Keep the 28-page imposition order in the scripts intact; changing it silently
  produces a misprinted booklet. Inspect the output PDF when touching those scripts.
- Do not push directly to `master` or `release`; `release` is written by CI. Never
  commit secrets — CI uses its own `GITHUB_TOKEN`.
- Both scripts take exactly two arguments (input PDF, output PDF). `canva_to_home_print.sh`
  writes a temporary `<input>-single.pdf` next to the input, so run it from a writable
  location and remove that temp file afterwards.
