<div align="center">

# git-dashboard-nvim
##### Your git contributions heatmap chart inside your favorite nvim dashboard.

[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
[![Neovim](https://img.shields.io/badge/Neovim%200.8+-green.svg?style=for-the-badge&logo=neovim)](https://neovim.io)

<img width="831" alt="image" src="https://github.com/juansalvatore/git-dashboard-nvim/assets/11010928/85609c97-22be-4a92-8f21-568c00f1d207">
</div>

### 🚧 Warning 
This plugin is in alpha version and you may encounter unexpected edge cases. I developed the plugin for personal use but I figured people might enjoy using it.
I may add breaking changes to improve the config in the future.

## ⇁ TOC
* [Intro](#-Intro)
* [Installation](#-Installation)
* [Getting Started](#-Getting-Started)
* [Config](#-Config)
* [Style Variations](#-Style-Variations)
* [Contribution](#-Contribution)
* [Social](#-Social)


## ⇁ Intro
`git-dashboard-nvim` is a modular solution to display your git commit contributions as an nvim heatmap dashboard that adapts to the current branch and repository.
It uses [vimdev/dashboard-nvim](https://github.com/nvimdev/dashboard-nvim) as the base for the dashboard and this plugin generates the header dynamically that we can pass to dashboard-nvim. 
It allows you to track project based progress in a visual way, making your nvim dashboard look cool while still being useful by showcasing the current git branch and project.
I've mainly developed this plugin for myself, so to make sure it looks well for you, check the [Style Variations](#-Style-Variations) section, to see some fun styling configurations.


## ⇁ Installation
* neovim 0.8.0+ required
* install using your favorite plugin manager (i am using `Lazy` in this case)
* install using [lazy.nvim](https://github.com/folke/lazy.nvim)
* Install [nvimdev/dashboard-nvim](https://github.com/nvimdev/dashboard-nvim)
  
```lua
{
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    dependencies = {
      { 'juansalvatore/git-dashboard-nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
    },
    opts = function()
      local git_dashboard = require('git-dashboard-nvim').setup {}

      local opts = {
        theme = 'doom',
        config = {
          header = git_dashboard,
          center = {
            { action = '', desc = '', icon = '', key = 'n' },
          },
          footer = function()
            return {}
          end,
        },
      }

      -- extra dashboard nvim config ...

      return opts
    end,
}
```

## ⇁ Getting Started
The dashboard by default will show a heatmap for the repo in which you are opening nvim and it will track the branch you are currently at (switching branches will change the heatmap to show commits in the respective branch).
By default it tracks all commits, but you can specify an author to just track their commits.

## ⇁ Config
This is the default config, feel free to change things around (some things like chaning months or day labels may look bad if more characters are added)
<details>
  <summary>Default config</summary>
  
```lua
      local git_dashboard = require('git-dashboard-nvim').setup {
        fallback_header = '',
        top_padding = 0,
        bottom_padding = 0,
        author = '',
        branch = 'main',
        gap = ' ',
        centered = true,
        day_label_gap = ' ',
        empty = ' ',
        empty_square = '□',
        filled_squares = { '■', '■', '■', '■', '■', '■' },
        hide_cursor = true,
        is_horizontal = true,
        show_contributions_count = true,
        show_only_weeks_with_commits = false,
        title = 'repo_name',
        show_current_branch = true,
        days = { 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' },
        months = { 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' },
        use_current_branch = true,
        colors = {
          days_and_months_labels = '#7eac6f',
          empty_square_highlight = '#54734a',
          filled_square_highlights = { '#2a3925', '#54734a', '#7eac6f', '#98c689', '#afd2a3', '#bad9b0' },
          branch_highlight = '#8DC07C',
          dashboard_title = '#a3cc96',
        },
      }

      local opts = {
        theme = 'doom',
        config = {
          header = git_dashboard,
          center = {
            { action = '', desc = '', icon = '', key = 'n' },
          },
          footer = function()
            return {}
          end,
        },
      }
```

**Config Definition**
```lua
---@class Colors
---@field days_and_months_labels string
---@field empty_square_highlight string
---@field filled_square_highlights string[]
---@field branch_highlight string
---@field dashboard_title string

---@class Config
---@field fallback_header string
---@field top_padding number
---@field bottom_padding number
---@field author string
---@field is_horizontal boolean
---@field branch string
---@field centered boolean
---@field gap string
---@field day_label_gap string
---@field empty string
---@field hide_cursor boolean
---@field empty_square string
---@field show_contributions_count boolean
---@field show_only_weeks_with_commits boolean
---@field filled_squares string[]
---@field title "owner_with_repo_name" | "repo_name" | "none"
---@field show_current_branch boolean
---@field days string[]
---@field months string[]
---@field use_current_branch boolean
---@field colors Colors
```
</details>

If you want to have an icons show (Eg. branch icon) install a nerd font and set
the following global in your `init.lua`:
```lua
vim.g.have_nerd_font = true
```

## ⇁ Style Variations
These are some suggested styles and dashboard variations.
If you decide to create your own feel free to commit your config with a screen capture and code!

### Default
<img width="1728" alt="image" src="https://github.com/juansalvatore/git-dashboard-nvim/assets/11010928/41c62850-b559-40cb-af68-235e2e938157">
<details>
  <summary>Code</summary>

  ```lua
      local ascii_heatmap = require('git-dashboard-nvim').setup {}

      local opts = {
        theme = 'doom',
        config = {
          header = ascii_heatmap,
          center = {
            { action = '', desc = '', icon = '', key = 'n' },
          },
          footer = function()
            return {}
          end,
        },
      }
```
</details>

### Only weeks with commits
<img width="1728" alt="image" src="https://github.com/juansalvatore/git-dashboard-nvim/assets/11010928/47192a22-d8ce-478f-9491-2f031166a982">
<details>
  <summary>Code</summary>

  ```lua
      local ascii_heatmap = require('git-dashboard-nvim').setup {
        show_only_weeks_with_commits = true,
      }

      local opts = {
        theme = 'doom',
        config = {
          header = ascii_heatmap,
          center = {
            { action = '', desc = '', icon = '', key = 'n' },
          },
          footer = function()
            return {}
          end,
        },
      }
```
</details>

### With repo owner
<img width="1728" alt="image" src="https://github.com/juansalvatore/git-dashboard-nvim/assets/11010928/93ed7bca-df18-4586-b5a1-bca7126923ca">
<details>
  <summary>Code</summary>

  ```lua
          local ascii_heatmap = require('git-dashboard-nvim').setup {
        title = 'owner_with_repo_name',
        show_only_weeks_with_commits = true,
      }

      local opts = {
        theme = 'doom',
        config = {
          header = ascii_heatmap,
          center = {
            { action = '', desc = '', icon = '', key = 'n' },
          },
          footer = function()
            return {}
          end,
        },
      }
```
</details>

### Updated day labels
<img width="1728" alt="image" src="https://github.com/juansalvatore/git-dashboard-nvim/assets/11010928/344b9f15-b5b2-4097-bb42-1861b39fd753">
<details>
  <summary>Code</summary>

  ```lua
      local ascii_heatmap = require('git-dashboard-nvim').setup {
        days = { 's', 'm', 't', 'w', 't', 'f', 's' },
      }

      local opts = {
        theme = 'doom',
        config = {
          header = ascii_heatmap,
          center = {
            { action = '', desc = '', icon = '', key = 'n' },
          },
          footer = function()
            return {}
          end,
        },
      }

```
</details>

### Updated empty square
<img width="1728" alt="image" src="https://github.com/juansalvatore/git-dashboard-nvim/assets/11010928/29b4fb39-8d8e-4503-aab7-d317ea679246">
<details>
  <summary>Code</summary>

  ```lua
      local ascii_heatmap = require('git-dashboard-nvim').setup {
        days = { 'в', 'п', 'в', 'с', 'ч', 'п', 'с' },
        show_only_weeks_with_commits = true,
        empty_square = ' ',
      }

      local opts = {
        theme = 'doom',
        config = {
          header = ascii_heatmap,
          center = {
            { action = '', desc = '', icon = '', key = 'n' },
          },
          footer = function()
            return {}
          end,
        },
      }
```
</details>

### Updated filled squares with different characters
<img width="1728" alt="image" src="https://github.com/juansalvatore/git-dashboard-nvim/assets/11010928/cfb44a10-69ba-4f6e-bc36-4e6a15e8f417">
<details>
  <summary>Code</summary>

  ```lua
      local ascii_heatmap = require('git-dashboard-nvim').setup {
        days = { 'в', 'п', 'в', 'с', 'ч', 'п', 'с' },
        show_only_weeks_with_commits = true,
        empty_square = ' ',
        filled_squares = { '', '', '', '', '', '' },
      }

      local opts = {
        theme = 'doom',
        config = {
          header = ascii_heatmap,
          center = {
            { action = '', desc = '', icon = '', key = 'n' },
          },
          footer = function()
            return {}
          end,
        },
      }
```
</details>

### Vertical with weekly commits
<img width="1728" alt="image" src="https://github.com/juansalvatore/git-dashboard-nvim/assets/11010928/5dd671ac-6edc-4055-a850-f610dfe08ae3">
<details>
  <summary>Code</summary>

  ```lua
      local ascii_heatmap = require('git-dashboard-nvim').setup {
        show_only_weeks_with_commits = true,
        is_horizontal = false,
      }

      local opts = {
        theme = 'doom',
        config = {
          header = ascii_heatmap,
          center = {
            { action = '', desc = '', icon = '', key = 'n' },
          },
          footer = function()
            return {}
          end,
        },
      }
```
</details>

### Vertical without weekly commits
<img width="1728" alt="image" src="https://github.com/juansalvatore/git-dashboard-nvim/assets/11010928/a5168e28-4e69-4add-89e1-233ab58535f8">
<details>
  <summary>Code</summary>

  ```lua
      local ascii_heatmap = require('git-dashboard-nvim').setup {
        show_only_weeks_with_commits = true,
        show_contributions_count = false,
        is_horizontal = false,
      }

      local opts = {
        theme = 'doom',
        config = {
          header = ascii_heatmap,
          center = {
            { action = '', desc = '', icon = '', key = 'n' },
          },
          footer = function()
            return {}
          end,
        },
      }
```
</details>

### Catppuccin theme
<img width="1728" alt="image" src="https://github.com/juansalvatore/git-dashboard-nvim/assets/11010928/ee821eef-6dfe-481b-93d6-c3fb703c1f29">
<details>
  <summary>Code</summary>

  ```lua
      local ascii_heatmap = require('git-dashboard-nvim').setup {
        show_only_weeks_with_commits = true,
        show_contributions_count = false,
        days = { 's', 'm', 't', 'w', 't', 'f', 's' },
        colors = {
          --catpuccin theme
          days_and_months_labels = '#8FBCBB',
          empty_square_highlight = '#3B4252',
          filled_square_highlights = { '#88C0D0', '#88C0D0', '#88C0D0', '#88C0D0', '#88C0D0', '#88C0D0', '#88C0D0' },
          branch_highlight = '#88C0D0',
          dashboard_title = '#88C0D0',
        },
      }

      local opts = {
        theme = 'doom',
        config = {
          header = ascii_heatmap,
          center = {
            { action = '', desc = '', icon = '', key = 'n' },
          },
          footer = function()
            return {}
          end,
        },
      }
```
</details>

### Different ascii characters
<img width="1728" alt="image" src="https://github.com/juansalvatore/git-dashboard-nvim/assets/11010928/617855ff-488c-440f-81a7-0fd91533ce78">
<details>
  <summary>Code</summary>

  ```lua
      local ascii_heatmap = require('git-dashboard-nvim').setup {
        show_only_weeks_with_commits = true,
        show_contributions_count = false,
        days = { 's', 'm', 't', 'w', 't', 'f', 's' },
        filled_squares = { '', '', '', '', '', '' },
        empty_square = '',
        colors = {
          -- tokinight colors
          days_and_months_labels = '#61afef',
          empty_square_highlight = '#3e4452',
          filled_square_highlights = { '#61afef', '#61afef', '#61afef', '#61afef', '#61afef', '#61afef' },
          branch_highlight = '#61afef',
          dashboard_title = '#61afef',
        },
      }

      local opts = {
        theme = 'doom',
        config = {
          header = ascii_heatmap,
          center = {
            { action = '', desc = '', icon = '', key = 'n' },
          },
          footer = function()
            return {}
          end,
        },
      }
```
</details>

### Different gap and fill ascii
<img width="1728" alt="image" src="https://github.com/juansalvatore/git-dashboard-nvim/assets/11010928/a4bc9e9d-35d4-4eee-8e80-021d0a786497">
<details>
  <summary>Code</summary>

  ```lua
      local ascii_heatmap = require('git-dashboard-nvim').setup {
        show_only_weeks_with_commits = true,
        show_contributions_count = false,
        days = { 's', 'm', 't', 'w', 't', 'f', 's' },
        filled_squares = { '█', '█', '█', '█', '█', '█' },
        empty_square = ' ',
        gap = '',
        colors = {
          -- tokinight colors
          days_and_months_labels = '#61afef',
          empty_square_highlight = '#3e4452',
          filled_square_highlights = { '#61afef', '#61afef', '#61afef', '#61afef', '#61afef', '#61afef' },
          branch_highlight = '#61afef',
          dashboard_title = '#61afef',
        },
      }

      local opts = {
        theme = 'doom',
        config = {
          header = ascii_heatmap,
          center = {
            { action = '', desc = '', icon = '', key = 'n' },
          },
          footer = function()
            return {}
          end,
        },
      }
```
</details>

### Vertical with different filled and empty squares, and different gap
<img width="1728" alt="image" src="https://github.com/juansalvatore/git-dashboard-nvim/assets/11010928/142e3f63-d8a8-46e9-89ae-c81f5cffc915">
<details>
  <summary>Code</summary>

  ```lua
      local ascii_heatmap = require('git-dashboard-nvim').setup {
        show_only_weeks_with_commits = true,
        show_contributions_count = false,
        is_horizontal = false,
        days = { 's', 'm', 't', 'w', 't', 'f', 's' },
        filled_squares = { '█', '█', '█', '█', '█', '█' },
        empty_square = ' ',
        gap = '',
        colors = {
          -- tokinight colors
          days_and_months_labels = '#61afef',
          empty_square_highlight = '#3e4452',
          filled_square_highlights = { '#61afef', '#61afef', '#61afef', '#61afef', '#61afef', '#61afef' },
          branch_highlight = '#61afef',
          dashboard_title = '#61afef',
        },
      }

      local opts = {
        theme = 'doom',
        config = {
          header = ascii_heatmap,
          center = {
            { action = '', desc = '', icon = '', key = 'n' },
          },
          footer = function()
            return {}
          end,
        },
      }
```
</details>

### Tracking more than one branch
<img width="1728" alt="image" src="https://github.com/juansalvatore/git-dashboard-nvim/assets/11010928/ee89b30e-fe27-4e04-8098-e7d66b1489cd">
<details>
  <summary>Code</summary>

  ```lua
          local ascii_heatmap = require('git-dashboard-nvim').setup {
        show_only_weeks_with_commits = true,
        show_contributions_count = false,
        use_current_branch = false,
        branch = 'main',
        title = 'owner_with_repo_name',
        top_padding = 15,
        centered = false,
        days = { 's', 'm', 't', 'w', 't', 'f', 's' },
        colors = {
          -- tokinight colors
          days_and_months_labels = '#61afef',
          empty_square_highlight = '#3e4452',
          filled_square_highlights = { '#61afef', '#61afef', '#61afef', '#61afef', '#61afef', '#61afef' },
          branch_highlight = '#61afef',
          dashboard_title = '#61afef',
        },
      }

      local ascii_heatmap2 = require('git-dashboard-nvim').setup {
        show_only_weeks_with_commits = true,
        show_contributions_count = false,
        use_current_branch = true,
        branch = 'main',
        centered = false,
        title = 'none',
        days = { 's', 'm', 't', 'w', 't', 'f', 's' },
        colors = {
          -- tokinight colors
          days_and_months_labels = '#61afef',
          empty_square_highlight = '#3e4452',
          filled_square_highlights = { '#61afef', '#61afef', '#61afef', '#61afef', '#61afef', '#61afef' },
          branch_highlight = '#61afef',
          dashboard_title = '#61afef',
        },
      }

      local header = {}

      for _, line in ipairs(ascii_heatmap) do
        table.insert(header, line)
      end

      for _, line in ipairs(ascii_heatmap2) do
        table.insert(header, line)
      end

      local opts = {
        theme = 'doom',
        config = {
          header = header,
          center = {
            { action = '', desc = '', icon = '', key = 'n' },
          },
          footer = function()
            return {}
          end,
        },
      }
```
</details>

### Fallback header for when you are not inside a git repository
<img width="1728" alt="image" src="https://github.com/juansalvatore/git-dashboard-nvim/assets/11010928/07c99abb-f775-4c23-9f55-1cc7476dd1a0">
<details>
  <summary>Code</summary>

  ```lua
          local ascii_heatmap = require('git-dashboard-nvim').setup {
        show_only_weeks_with_commits = true,
        show_contributions_count = false,
        use_current_branch = false,
        branch = 'main',
        title = 'owner_with_repo_name',
        top_padding = 15,
        centered = false,
        days = { 's', 'm', 't', 'w', 't', 'f', 's' },
        colors = {
          -- tokinight colors
          days_and_months_labels = '#61afef',
          empty_square_highlight = '#3e4452',
          filled_square_highlights = { '#61afef', '#61afef', '#61afef', '#61afef', '#61afef', '#61afef' },
          branch_highlight = '#61afef',
          dashboard_title = '#61afef',
        },
      }

      local ascii_heatmap2 = require('git-dashboard-nvim').setup {
        show_only_weeks_with_commits = true,
        show_contributions_count = false,
        use_current_branch = true,
        branch = 'main',
        centered = false,
        title = 'none',
        days = { 's', 'm', 't', 'w', 't', 'f', 's' },
        colors = {
          -- tokinight colors
          days_and_months_labels = '#61afef',
          empty_square_highlight = '#3e4452',
          filled_square_highlights = { '#61afef', '#61afef', '#61afef', '#61afef', '#61afef', '#61afef' },
          branch_highlight = '#61afef',
          dashboard_title = '#61afef',
        },
      }

      local header = {}

      for _, line in ipairs(ascii_heatmap) do
        table.insert(header, line)
      end

      for _, line in ipairs(ascii_heatmap2) do
        table.insert(header, line)
      end

      local opts = {
        theme = 'doom',
        config = {
          header = header,
          center = {
            { action = '', desc = '', icon = '', key = 'n' },
          },
          footer = function()
            return {}
          end,
        },
      }
```
</details>

### Showing a center section
<img width="1728" alt="image" src="https://github.com/juansalvatore/git-dashboard-nvim/assets/11010928/c57632d0-631c-475b-a128-f557bf7aeae9">

<details>
  <summary>Code</summary>

  ```lua
      local git_dashboard = require('git-dashboard-nvim').setup {
        centered = false,
        top_padding = 19,
        bottom_padding = 2,
      }

      local opts = {
        theme = 'doom',
        config = {
          header = git_dashboard,
          center = {
            { action = 'ene | startinsert', desc = ' New File', icon = ' ', key = 'n' },
            { action = 'Telescope oldfiles', desc = ' Recent Files', icon = ' ', key = 'r' },
            { action = 'Telescope live_grep', desc = ' Find Text', icon = ' ', key = 'g' },
            { action = 'Lazy', desc = ' Lazy', icon = '󰒲 ', key = 'l' },
            { action = 'qa', desc = ' Quit', icon = ' ', key = 'q' },
          },
          footer = function()
            return {}
          end,
        },
      }
```
</details>

## ⇁ Contribution
This project open source, so feel free to fork if you want very specific functionality. If you wish to
contribute I am totally willing for PRs, as long as your PR leaves the default look 
and functionality intact I will accept features that build on top or improve things.
I started using nvim around two months ago along with lua, so this is a project I mainly built for myself and to learn a bit more about lua and nvim,
but given that I think someone else may enjoy having this as their dashboard I decided to make it open source.

**Tests**
I'm using [plenary](https://github.com/nvim-lua/plenary.nvim) and for now I'm just running them using <Plug>PlenaryTestFile %

## ⇁ Social
* [Twitter](https://twitter.com/jnsalvatore)
