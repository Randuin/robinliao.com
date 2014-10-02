---
layout: post
title: "Easy uploads for a post"
slug: "easy-uploads-for-a-post"
date: 2013-03-12
comments: true
categories: 
- Octopress
- Ruby
- Jekyll
---

So I've recently gotten into blogging with Octopress and one thing that bugged me coming from using traditional CMS's ([Wordpress](http://wordpress.org/) mostly) is that there are way too many steps for uploading an image and it can get very messy in the organization of it. With some quick hacking I've gotten the upload process to look like the following:

![](/images/posts/2013/interaction.jpg)

<!--more-->

To use it on the site it's just one simple custom tag

`{% post_image drag-in.jpg %}`

The code looks like the following

{{% highlight ruby %}}
```
module Jekyll
  class PostImage < Jekyll::ImageTag
    def initialize(tag_name, markup, tokens)
      markup = "/#{markup}"
      super
    end

    def render(context)
      page = context.environments.first['page']
      unless page.nil? || page['date'].nil? || page['title'].nil?
        title = page['title'].to_url
        date = page['date'].strftime('%Y-%m-%d')
        @img['src'] = "/assets/posts/#{date}-#{title}#{@img['src']}" 
      else
        ""
      end

      super
    end
  end
end

Liquid::Template.register_tag('post_image', Jekyll::PostImage)
```
{{% /highlight %}}

This is the helper that will add in the custom helper for your posts to use

And add the following to your Rakefile

{{% highlight ruby %}}
```
SOURCE_POST_DIR = [ source_dir, posts_dir ].join('/')

desc "Upload a file for posts to reference"
task :upload do |args|
  post_name = choose_post
  post_asset_dir = File.join(__dir__, source_dir, assets_dir, 'posts', post_name)
  FileUtils.mkdir_p(post_asset_dir)
  file_name = Pathname.new(get_stdin('Where is the file you want to upload? ').strip)
  FileUtils.cp(file_name, File.join(post_asset_dir, file_name.basename))
end

def choose_post
  msg = "(\e[31mn\e[0m) To next page (\e[33m1-9\e[0m) to pick the post: "

  files = Dir[File.join(__dir__, SOURCE_POST_DIR, '*')]
  files.map!{ |file| file.split('/').last.split('.markdown').first }
  files.each_slice(9) do |fs|
    i = 1
    fs.each do |file|
      puts "(\e[33m#{i}\e[0m) #{file}"
      i += 1
    end

    input = get_stdin(msg).to_i

    case input
    when 0
      next
    when 1..9
      return fs[input.to_i-1]
    end
  end
end
```
{{% /highlight %}}

Now you can simply run

`rake upload`

And you'll be greeted with the dialog from above! You can even drag in pictures into your console in many terminal emulators such as the following!

![Alt text](/images/posts/2013/drag-in.jpg)

Happy blogging!

