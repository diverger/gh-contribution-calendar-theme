# GitHub Contribution Calendar Theme Detector

A GitHub Action that detects the current GitHub contribution calendar theme and extracts the color palettes for both light and dark modes.

GitHub changes the contribution calendar colors during special holidays (Halloween 🎃, Christmas 🎄, Lunar New Year 🧧, Valentine's Day 💝, Pride Month 🏳️‍🌈, etc.). This action helps you detect which theme is active and get the exact color values.

## Features

- 🎨 Extracts actual color values from GitHub's contribution calendar
- 🌓 Supports both light and dark theme colors
- 🎃 Detects holiday themes (Halloween, Christmas, Lunar New Year, Valentine's, Pride)
- 🔄 Multiple detection methods (CSS variables + date-based fallback)
- ⚡ Fast execution using Bun runtime
- � **Docker-based** - Pre-built image for instant execution (no setup time!)
- �📊 Returns colors as both arrays and simple palettes

## Usage

### Basic Example

```yaml
name: Detect GitHub Theme
on:
  schedule:
    - cron: '0 0 * * *'  # Run daily
  workflow_dispatch:

jobs:
  detect-theme:
    runs-on: ubuntu-latest
    steps:
      - name: Detect contribution calendar theme
        id: theme
        uses: YOUR-USERNAME/gh-contribution-calendar-theme@v1
        with:
          github-username: octocat

      - name: Display results
        run: |
          echo "Holiday detected: ${{ steps.theme.outputs.holiday_detected }}"
          echo "Theme name: ${{ steps.theme.outputs.theme_name }}"
          echo "Detection method: ${{ steps.theme.outputs.detection_method }}"
          echo "Light colors: ${{ steps.theme.outputs.light_color_palette }}"
          echo "Dark colors: ${{ steps.theme.outputs.dark_color_palette }}"
```

### Version References

You can reference this action using different version levels:

```yaml
# Major version (recommended - gets latest v1.x.x)
uses: YOUR-USERNAME/gh-contribution-calendar-theme@v1

# Minor version (gets latest v1.0.x)
uses: YOUR-USERNAME/gh-contribution-calendar-theme@v1.0

# Specific patch version (pinned to exact release)
uses: YOUR-USERNAME/gh-contribution-calendar-theme@v1.0.0
```

### Use Theme Colors in Your Project

```yaml
name: Update Theme Colors
on:
  schedule:
    - cron: '0 0 * * *'  # Run daily

jobs:
  update-colors:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Detect GitHub theme
        id: theme
        uses: YOUR-USERNAME/gh-contribution-calendar-theme@v1

      - name: Update CSS variables
        run: |
          cat > theme.css << EOF
          :root {
            --github-theme: ${{ steps.theme.outputs.theme_name }};
            --github-colors-light: ${{ steps.theme.outputs.light_color_palette }};
            --github-colors-dark: ${{ steps.theme.outputs.dark_color_palette }};
          }
          EOF

      - name: Commit changes
        run: |
          git config user.name github-actions
          git config user.email github-actions@github.com
          git add theme.css
          git diff --quiet && git diff --staged --quiet || git commit -m "Update GitHub theme colors"
          git push
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `github-username` | GitHub username to check for contribution calendar theme | No | Repository owner |

## Outputs

| Output | Description | Example |
|--------|-------------|---------|
| `holiday_detected` | Whether a holiday theme is active | `true` or `false` |
| `theme_name` | Name of the detected theme | `halloween`, `christmas`, `default` |
| `detection_method` | Method used to detect the theme | `css-variable`, `date`, `none` |
| `light_color_palette` | Comma-separated light theme colors | `#ebedf0, #9be9a8, #40c463, #30a14e, #216e39` |
| `dark_color_palette` | Comma-separated dark theme colors | `#161b22, #0e4429, #006d32, #26a641, #39d353` |
| `light_grid_colors` | JSON array with level/color pairs for light theme | `[{"level":0,"color":"#ebedf0"}]` |
| `dark_grid_colors` | JSON array with level/color pairs for dark theme | `[{"level":0,"color":"#161b22"}]` |
|-------|-------------|----------|---------|
| `github-username` | GitHub username to check for contribution calendar theme | No | Repository owner |
