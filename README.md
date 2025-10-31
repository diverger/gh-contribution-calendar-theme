# GitHub Contribution Calendar Theme Detector

A GitHub Action that detects the current GitHub contribution calendar theme and extracts the color palettes for both light and dark modes.

GitHub changes the contribution calendar colors during special holidays — examples:

- Halloween 🎃 (:jack_o_lantern:)
- Christmas 🎄 (:christmas_tree:)
- Lunar New Year 🧧 (:red_envelope:)
- Valentine's Day 💝 (:gift_heart:)

This action helps you detect which theme is active and get the exact color values.

> **⚠️ Important Note**: This action detects themes in **unauthenticated (anonymous) mode**, which reflects GitHub's display based on **UTC timezone**. Logged-in users may see different themes based on their account timezone settings. For example, on October 31st at 8 PM UTC, anonymous users see the Halloween theme, but users in UTC+8 (November 1st) may already see the default theme.

## Features

- 🎨 Extracts actual color values from GitHub's contribution calendar
- 🌓 Supports both light and dark theme colors
- 🎃 Detects holiday themes (Halloween, Christmas, Lunar New Year, Valentine's, Pride)
- ⚡ Fast execution using Bun runtime
- 🐳 **Docker-based** - Pre-built image for instant execution (no setup time!)
- 📊 Returns colors as both arrays and simple palettes

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
| `timezone` | Timezone for holiday detection. Supports IANA format (e.g., `America/New_York`, `Asia/Shanghai`) or simple aliases (e.g., `china`, `tokyo`, `london`, `est`, `pst`). See [IANA timezones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) for all valid values. | No | `UTC` |

### Timezone Configuration

> **Note**: The `timezone` parameter is currently **not functional** for theme detection because GitHub determines holiday themes server-side for unauthenticated users based on UTC time. This parameter is reserved for potential future features or authenticated detection modes.

GitHub displays holiday themes based on the user's **local timezone** when logged in, but this action detects themes in **anonymous mode**, which uses GitHub's server time (UTC). To understand what theme will be detected:

**Current behavior:**
- Detection always uses **UTC timezone** (server-side rendering)
- Timezone parameter does not affect detection results
- Results reflect what anonymous/logged-out users see

**Using IANA timezone format (for future compatibility):**
```yaml
- uses: YOUR-USERNAME/gh-contribution-calendar-theme@v1
  with:
    github-username: octocat
    timezone: 'Asia/Shanghai'  # China (Beijing Time)
```

**Using simple aliases (case-insensitive):**
```yaml
- uses: YOUR-USERNAME/gh-contribution-calendar-theme@v1
  with:
    timezone: 'china'      # → Asia/Shanghai
    # Other aliases: tokyo, london, paris, berlin, moscow
    # US: est, cst, mst, pst, eastern, central, mountain, pacific
```

**Supported timezone aliases:**

| Alias | Resolved To | Region |
|-------|-------------|--------|
| `china`, `beijing`, `shanghai` | `Asia/Shanghai` | China |
| `tokyo` | `Asia/Tokyo` | Japan |
| `seoul` | `Asia/Seoul` | South Korea |
| `hongkong` | `Asia/Hong_Kong` | Hong Kong |
| `singapore` | `Asia/Singapore` | Singapore |
| `dubai` | `Asia/Dubai` | UAE |
| `london` | `Europe/London` | UK |
| `paris` | `Europe/Paris` | France |
| `berlin` | `Europe/Berlin` | Germany |
| `moscow` | `Europe/Moscow` | Russia |
| `est`, `eastern` | `America/New_York` | US Eastern |
| `cst`, `central` | `America/Chicago` | US Central |
| `mst`, `mountain` | `America/Denver` | US Mountain |
| `pst`, `pacific` | `America/Los_Angeles` | US Pacific |
| `sydney` | `Australia/Sydney` | Australia |
| `melbourne` | `Australia/Melbourne` | Australia |

## Outputs

| Output | Description | Example |
|--------|-------------|---------|
| `holiday_detected` | Whether a holiday theme is active | `true` or `false` |
| `theme_name` | Name of the detected theme | `halloween`, `christmas`, `default` |
| `light_color_palette` | Comma-separated light theme colors | `#ebedf0, #9be9a8, #40c463, #30a14e, #216e39` |
| `dark_color_palette` | Comma-separated dark theme colors | `#161b22, #0e4429, #006d32, #26a641, #39d353` |
| `light_grid_colors` | JSON array with level/color pairs for light theme | `[{"level":0,"color":"#ebedf0"}]` |
| `dark_grid_colors` | JSON array with level/color pairs for dark theme | `[{"level":0,"color":"#161b22"}]` |
