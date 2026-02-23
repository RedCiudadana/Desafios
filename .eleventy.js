const moment = require("moment");
const rmj = require('render-markdown-js');

module.exports = function (eleventyConfig) {

    eleventyConfig.setTemplateFormats("njk,html,md");

    eleventyConfig.addPassthroughCopy('assets', { expand: true });
    eleventyConfig.addPassthroughCopy('admin', { expand: true });
    eleventyConfig.addPassthroughCopy('images', { expand: true });

    eleventyConfig.setServerOptions({
        watch: ['assets/**/*', 'admin/**/*', 'images/**/*']
    });

    eleventyConfig.addNunjucksFilter("rmj", function(content) {
        return rmj(content);
    });

    eleventyConfig.addNunjucksFilter("limit", function (array, limit) {
        return array.slice(0, limit);
    });

    eleventyConfig.addFilter("dateFormat", function(date, format) {
        return moment(date).format(format);
    });
}
