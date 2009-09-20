class Main
  helpers do

    # helper for image_tags
    # EX : image 'logo.jpg'
    #  => <img src="images/logo.jpg" />
    def image(src,options={})
      options[:src] = "/images/#{src}"
      single_tag(:img, options)
    end
    
    # css link helper
    # EX : link_css 'default'
    #  => <link rel="stylesheet" href="/css/default.css" type="text/css" media="screen" title="no title" charset="utf-8">
    def link_css(srcs,options={})
      srcs_length = srcs.split(",").length
      options[:media] ||=  "screen"
      options[:type] ||= "text/css"
      options[:rel] ||= "stylesheet"
      content = ""
      if srcs_length == 1
        options[:href] = "/css/#{srcs}.css"
        content = single_tag(:link, options)
      else
        srcs.split(",").each do |src|
          options[:href] = "/css/#{src.strip}.css"
          content << single_tag(:link, options)
          content << "\n"
        end
      end
      content
    end
    
    # js link helper 
    # EX : link_js 'app'
    #  => <script src="/js/app.js" type="text/javascript" />  
    # EX : link_js "app,jquery"
    #  => <script src="/js/app.js" type="text/javascript" />
    #  => <script src="/js/jquery.js" type="text/javascript" />
    def link_js(srcs,options={})
      srcs_length = srcs.split(",").length
      content = ""
      if srcs_length == 1
        content = tag(:script,"", :src => "/js/#{srcs}.js", :type => "text/javascript")
      else
        srcs.split(",").each do |src|
          content << tag(:script,"", :src => "/js/#{src.strip}.js", 
                                :type => "text/javascript")
          content << "\n"
        end
      end
      content
    end
    
    # standard anchor links, like rails' link_to
    # EX : link "google", "http://google.com"
    # => <a href="http://google.com">google</a>
    def link(content,href,options={})
      options.update :href => href
      tag :a, content, options
    end

    # standard open and close tags
    # EX : tag :h1, "shizam", :title => "shizam"
    # => <h1 title="shizam">shizam</h1>
    def tag(name,content,options={})
      with_opts = "<#{name.to_s} #{options.to_html_attrs}>#{content}</#{name}>"
      no_opts = "<#{name.to_s}>#{content}</#{name}>"
      options.blank? ? no_opts : with_opts
    end

    # standard single closing tags
    # single_tag :img, :src => "images/google.jpg"
    # => <img src="images/google.jpg" />
    def single_tag(name,options={})
      options ||= options.stringify_keys
      "<#{name.to_s} #{options.to_html_attrs} />"
    end
    
  end
  
end

class Hash
  
  def to_html_attrs
    html_attrs = ""
    self.stringify_keys.each do |key, val| 
      html_attrs << "#{key}='#{val}' "
    end
    html_attrs.chop
  end
  
end
