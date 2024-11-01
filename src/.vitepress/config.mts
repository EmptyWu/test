import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  base:'/test/',
  locales: {
    root: {
      label: 'English',
      lang: 'en',
      dir: '/src/en',
      title: 'e-docs',
      description: "e",
    },
    zhtw: {
      label: '繁體中文',
      lang: 'zhtw',
      dir: '/src/zhtw',
      title: 'e-文件中心',
      description: "e",
      themeConfig: {
        nav: [
          // { text: '首頁', link: '/zhtw/index' },
          { text: '範例', link: '/zhtw/examples/markdown-examples', activeMatch: '/zhtw/examples/' },
          { text: '捐贈', link: '/zhtw/other/donate' },
          { text: 'Emoji', link: '/zhtw/other/emoji' }
        ],
        sidebar: {
          '/zhtw/examples/': [
            {
              text: 'Examples',
              items: [
                { text: '範例', link: '/zhtw/examples/markdown-examples' },
                { text: 'API-範例', link: '/zhtw/examples/api-examples' }
              ]
            }
          ]
        },
        footer: {
          message: '根据 MIT 许可证发布',
          copyright: 'Copyright © 2024 e'
        }
      }
    }
  },
  assetsDir: 'public',
  srcDir: '.',
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      // { text: 'index', link: '/' },
      { text: 'example', link: '/examples/markdown-examples', activeMatch: '/examples/' },
      { text: 'Donate', link: '/other/donate' },
      { text: 'Emoji', link: '/other/emoji' }

    ],

    sidebar: {
      '/examples/': [
        {
          text: 'Examples',
          items: [
            { text: 'Examples', link: '/examples/markdown-examples' },
            { text: 'API Examples', link: '/examples/api-examples' }
          ]
        }
      ],

    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/vuejs/vitepress' },
      { icon: 'discord', link: 'https://x' },
    ]
    ,
    footer: {
      message: 'Publish under the MIT license',
      copyright: 'Copyright © 2024 e'
    }
  }
})
