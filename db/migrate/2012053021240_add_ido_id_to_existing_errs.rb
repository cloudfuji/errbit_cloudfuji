class AddIdoIdToExistingErrs < Mongoid::Migration
  def self.up
    errs = Err.where(:ido_id => nil).all
    puts "Generating 'ido_id's for #{errs.size} Errs..."
    errs.each do |err|
      err.update_attribute :ido_id, UUID.new.generate
    end
  end
end
