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
    {
      'williamboman/mason.nvim',
      opts = {
        registries = {
          'github:nvim-java/mason-registry',
          'github:mason-org/mason-registry',
        },
      },
    },
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