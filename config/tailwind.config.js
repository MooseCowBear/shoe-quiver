const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
      colors: {
        eggplant: {
          DEFAULT: "#1a535c",
        },
        mint: {
          DEFAULT: "#4ecdc4",
        },
        mustard: {
          DEFAULT: "#ffe66d",
        },
        poppy: {
          DEFAULT: "#ff6b6b",
        },
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
  safelist: [
    {
      pattern: /(bg|text|border|fill)-(eggplant|mint|mustard|poppy)/,
    },
  ],
};
