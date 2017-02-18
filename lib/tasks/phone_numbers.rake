namespace :phone_numbers do
  desc 'Check suspect formatting of phone numbers'
  task formatting: :environment do
    landlines = PhoneNumberFormat.new
    cell_phones = PhoneNumberFormat.new

    File.open(File.join(Rails.root, 'log', 'suspect_phone_number_formats.tsv'), 'w') do |log|
      log.puts "Username\tPhone Type\tPhone Number\tReasons"

      User.find_each do |user|

        unless user.phone.nil?
          landlines.number = user.phone
          invalid_landline = landlines.validate

          if invalid_landline
            log.puts "#{user.username}\tlandline\t#{user.phone}\t#{invalid_landline.join(", ")}"
          end
        end

        unless user.cell_phone.nil?
          cell_phones.number = user.cell_phone
          invalid_cell_phone = cell_phones.validate

          if invalid_cell_phone
            log.puts "#{user.username}\tcell_phone\t#{user.cell_phone}\t#{invalid_cell_phone.join(", ")}"
          end
        end
      end
    end

    File.open(File.join(Rails.root, 'log', 'suspect_phone_number_formats_stats.tsv'), 'w') do |log|
      log.puts "Number of employees\t#{User.count}"

      log.puts "\n\n#{'Landline numbers'.upcase}"
      log.puts "Missing landline number\t#{User.where(phone: nil).count}"
      log.puts "Has switchboard landline number\t#{landlines.stats['switchboard_number']}"

      landlines.all_validators.each do |stat|
        log.puts "#{stat}\t#{landlines.stats[stat]}"
      end

      log.puts "\n\n#{'Cellphone numbers'.upcase}"
      log.puts "Missing cellphone number\t#{User.where(cell_phone: nil).count}"
      cell_phones.all_validators.each do |stat|
        log.puts "#{stat}\t#{cell_phones.stats[stat]}"
      end
    end
    puts 'Done'
  end
end

class PhoneNumberFormat
  attr_accessor :all_validators, :number, :stats

  def initialize
    @all_validators = %w(
      no_hyphen_or_endash
      too_short
      starts_without_zero
      no_spaces
      has_space_around_hyphen_or_endash
      switchboard_number
    )
    # no_hyphen
    # no_endash

    @stats = {}

    @all_validators.each do |stat|
      @stats[stat] = 0
    end
  end

  def validate
    suspects = []

    @all_validators.each do |validator|
      if send("#{validator}?".to_sym)
        @stats[validator] += 1
        suspects << validator
      end
    end

    suspects
  end

  def no_hyphen?
    !@number.match('-')
  end

  def no_endash?
    !@number.match('–')
  end

  def no_hyphen_or_endash?
    no_hyphen? && no_endash?
  end

  def too_short?
    @number.size < 9
  end

  def starts_without_zero?
    !@number.match(/^0/)
  end

  def no_spaces?
    !@number.match(' ')
  end

  def has_space_around_hyphen_or_endash?
    !@number.match(/\d(-|–)\d/)
  end

  def switchboard_number?
    @number.match(/4\s*1\s*0\s*0\s*0\s*$/)
  end
end
