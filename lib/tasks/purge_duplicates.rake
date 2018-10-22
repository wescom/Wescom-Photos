namespace :wescom do
  desc "Delete duplicates"

  task :purge_dup_pdfs  => :environment do
    # Get a hash of all pdf image file names and how many records of each group
    counts = PdfImage.group([:image_file_name]).count
    #puts "Every PDF duplicate count: "+counts.to_yaml

    # Keep only those pairs that have more than one record, thus duplicates
    dupes = counts.select{|attrs, count| count > 1}
    dupe_count = dupes.count
    puts "*** PDF Duplicate 2 or more: "+dupes.to_yaml
    puts "*** Number of PDFs with duplicates: "+dupe_count.to_s

    # Map objects by the attributes we have.
    object_groups = dupes.map do |attrs, count|
      #puts "attrs: "+attrs
      PdfImage.where(:image_file_name => attrs)
    end

    # Take each group and destroy the duplicate pdf images, keeping only the first one.
    object_groups.each do |group|
      puts "Duplicate Record = " + group[0].doc_name
      group.each_with_index do |object, index|
        #puts "Duplicate Record=  "+"id:"+object.id.to_s + ", " + object.image_file_name unless index == 0
        object.destroy unless index == 0
      end
    end
  end

  task :delete_pdf_by_year  => :environment do
    #find_date = Date.new('2009-01-01')
    find_year = 2012
    pdf_images = PdfImage.where('Year(pubdate) = ?', find_year).order_by_pubdate_section_page
    pdf_images.each  { |pdf|
      puts "ID:"+pdf.id.to_s + ", " + pdf.image_file_name+", = "+ pdf.count.to_s
    }
  end
    
  task :purge_dup_stories  => :environment do
    puts ""
    puts "Rake Task:  wescom:purge_dup_stories"
    puts "   searching database for duplicate stories ..."

    # Get a hash of all pdf image file names and how many records of each group
    counts = Story.group([:doc_id]).count
    #puts "Every Story duplicate count: "+counts.to_yaml

    # Keep only those pairs that have more than one record, thus duplicates
    dupes = counts.select{|attrs, count| count > 1}
    dupe_count = dupes.count
    #puts "*** Story Duplicate 2 or more: "+dupes.to_yaml
    puts "*** Number of stories with duplicates: "+dupe_count.to_s

    # Map objects by the attributes we have.
    object_groups = dupes.map do |attrs, count|
      #puts "attrs: "+attrs
      Story.where(:doc_id => attrs)
    end

    # Take each group and destroy the duplicate, keeping only the first one.
    object_groups.drop(1).each do |group|
#      if group[0].created_at.utc >= (Time.now - 2.days).utc
        #puts "Duplicate Record for Story: #" + group[0].doc_id.to_s + " - " + group[0].doc_name
        group.each_with_index do |object, index|
          #puts "Duplicate Record=  "+"id:"+object.id.to_s + ", " + object.doc_name #unless index == 0

          if index != 0
            # Check if attached images have been sold on WescomPhotos. Do NOT delete is any sold.
            @story_images_sold = OrderItem.find_by_item_id(object.id)
            if @story_images_sold
              puts "     Do NOT delete Story ID: "+object.id.to_s + ", " + object.doc_name
            else
              puts "     Delete Story ID: "+object.id.to_s + ", " + object.doc_name
#            object.destroy unless index == 0
            end
          end
        end
#      end
    end
  end

end