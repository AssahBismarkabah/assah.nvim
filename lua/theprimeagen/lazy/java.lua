return {
  'nvim-java/nvim-java',
  event = 'VeryLazy',  -- Load early
  dependencies = {
    'nvim-java/lua-async-await',
    'nvim-java/nvim-java-core',
    'nvim-java/nvim-java-test',
    'nvim-java/nvim-java-dap',
    'MunifTanjim/nui.nvim',
    'neovim/nvim-lspconfig',
    'mfussenegger/nvim-dap',
  },
  config = function()
    require('java').setup({
      -- Project root detection
      root_markers = {
        'settings.gradle',
        'settings.gradle.kts',
        'pom.xml',
        'build.gradle',
        'mvnw',
        'gradlew',
        'build.gradle.kts',
        '.git',
      },
      
      -- Language server settings
      lsp = {
        server_settings = {
          -- Specify the bundles to be loaded by the language server
          bundles = (function()
            local bundles = {}
            local mason_pkg_path = vim.fn.stdpath('data') .. '/mason/packages/'
            local java_test_pkg = mason_pkg_path .. 'java-test/extension/server/com.microsoft.java.test.plugin-*.jar'
            local java_decompiler_pkg = mason_pkg_path .. 'vscode-java-decompiler/server/fernflower.jar'

            local test_bundle = vim.fn.glob(java_test_pkg, 1)
            if test_bundle[1] then
              vim.list_extend(bundles, test_bundle)
            end

            local decompiler_bundle = vim.fn.glob(java_decompiler_pkg)
            if decompiler_bundle ~= '' then
              table.insert(bundles, decompiler_bundle)
            end

            return bundles
          end)(),
        },
      },

      -- Auto-install JDK via Mason
      jdk = {
        auto_install = true,
        version = '21',  -- Default JDK version
      },
      
      -- Enable all Java development features
      java_test = {
        enable = true,
      },
      
      java_debug_adapter = {
        enable = true,
      },
      
      spring_boot_tools = {
        enable = true,
      },
      
      notifications = {
        dap = true,  -- Show DAP configuration messages
      },
      
      -- Verification settings (reduced to avoid conflicts)
      verification = {
        invalid_order = false,
        duplicate_setup_calls = false,
        invalid_mason_registry = false,
      },
    })
  end,
} 