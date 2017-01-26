module ApplicationHelper


  def strip_subhead_tags(text)
    text.html_safe.gsub(/<p class="hl2_chapterhead">/, '<p>')
  end

end
