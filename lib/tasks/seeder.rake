task :seeder => "seeder:model"

namespace :seeder do

  #  Command Examples
  #    Save to db/fixtures/orders.rb
  #      bundle exec rake seeder:orders
  #    Print to console
  #      bundle exec rake seeder:orders print=true
  #
  #    All records of any specified model and print to console
  #      bundle exec rake seeder model=User print=true
  #
  #  Examples of make_seed
  #    make_seed(order, {:title => true, :exclude => %w[created_at updated_at], :constraints => ':id'})
  #    order.lines.each { |line| make_seed(line, :include => %w[id order_id]) }
  #
  #  Example output
  #    # =============== WeeklyDelivery 10 ===============
  #
  #    WeeklyDelivery.seed(:id) do |s|
  #      s.id = "10"
  #      s.state = "complete"
  #      s.user_id = "4"
  #      s.lines_total = "0.0"
  #      s.submitted_at = ""
  #    end
  #
  #    Line.seed(:id) do |s|
  #      s.id = "26"
  #      s.order_id = "10"
  #      s.variant_id = "101"
  #      s.quantity = "1"
  #      s.price = "16.0"
  #    end
  #
  #  Example
  #    make_seed(adjuster, {:title => true, :exclude => %w[created_at updated_at], :additional => %w[variant_ids]})
  #
  #  Output
  #    =============== Adjuster::Bulk 1 ===============
  #
  #    Adjuster::Bulk.seed(:id) do |s|
  #      s.id = 1
  #      s.type = "Adjuster::Bulk"
  #      s.description = "Book Bulk Discount"
  #      s.starting_on = nil
  #      s.ending_on = nil
  #      s.expired = false
  #      s.settings = {:discounts => {"21" => "35"}}
  #      s.variant_ids = [101, 111]
  #    end


  desc "Seed All of specified model (ex. model=WeeklyDelivery)"
  task :model => :environment do
    model = ENV['model'].constantize
    seed(model.name.pluralize.downcase) do
      model.all.each { |r| make_seed(r, {:title => true}) }
    end
  end

  desc "Seed locations"
  task locations: :environment do

    seed("locations") do
      
      Address.all.each do |item|
        make_seed(item, {title: true})
      end

      Location.all.each do |item|
        make_seed(item, {title: true, additional: [:user_ids]})
      end

      Seo.all.each do |item|
        make_seed(item, {title: true})
      end
    end
  end

  desc "Seed all models"
  task all: :environment do

    seed("all") do
      User.all.each do |item|
        make_seed(item, {title: true})
      end
      
      Address.all.each do |item|
        make_seed(item, {title: true})
      end

      Article.all.each do |item|
        make_seed(item, {title: true})
      end

      Banner.all.each do |item|
        make_seed(item, {title: true})
      end

      Booking.all.each do |item|
        make_seed(item, {title: true})
      end

      Contact.all.each do |item|
        make_seed(item, {title: true})
      end

      Donation.all.each do |item|
        make_seed(item, {title: true})
      end

      Event.all.each do |item|
        make_seed(item, {title: true, additional: [:user_ids]})
      end

      Itinerary.all.each do |item|
        make_seed(item, {title: true})
      end

      Location.all.each do |item|
        make_seed(item, {title: true, additional: [:user_ids]})
      end

      Mission.all.each do |item|
        make_seed(item, {title: true, additional: [:user_ids]})
      end

      Navigation.all.each do |item|
        make_seed(item, {title: true})
      end

      Page.all.each do |item|
        make_seed(item, {title: true})
      end

      Payment.all.each do |item|
        make_seed(item, {title: true})
      end

      PaymentSchedule.all.each do |item|
        make_seed(item, {title: true})
      end

      Seo.all.each do |item|
        make_seed(item, {title: true})
      end

      Training.all.each do |item|
        make_seed(item, {title: true, additional: [:user_ids]})
      end
    end
  end

  # ==============================================================================================

  def seed(filename_base)
    header
    yield
    save_data filename_base
  end

  def header
    @data = "# Generated at #{Time.now} with\n"
    @data += "#   #{$0} #{$*.join(' ')}\n\n"
  end

  def make_seed(model, options = {})
    options = {:constraints => ":id"}.merge(options)
    @data += "# =============== #{model.class.name} #{model.id} ===============\n\n" if options[:title]
    @data += "#{model.class.name}.seed(#{options[:constraints]}) do |s|\n"
    model.attributes.each do |key, value|
      next if options[:exclude] && options[:exclude].include?(key)
      next if options[:include] && !options[:include].include?(key)
      if value.class.name == "Money"
        value_str = value.to_s
      elsif value.is_a? BigDecimal
        value_str = value.to_s
      elsif value.is_a?(Time) || value.is_a?(Date)
        value_str = %["#{value.to_s}"]
      else
        value_str = value.inspect
      end
      @data += %[  s.#{key} = #{value_str}\n]
    end
    if options[:additional]
      options[:additional].each do |attr|
        @data += %[  s.#{attr} = #{model.send(attr).inspect}\n]
      end
    end
    @data += "end\n\n"
  end

  def save_data(name)
    filename = "#{Rails.root}/db/fixtures/#{name}.rb"
    if ENV['print'] && ENV['print'] == 'true'
      puts @data
      puts "Seed data would be written to #{filename}"
    else
      File.open(filename, 'w') { |f| f.write(@data) }
      puts "Seed data written to #{filename}"
    end
  end

end