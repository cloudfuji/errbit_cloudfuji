class AddIdoIdToExistingErrs < Mongoid::Migration
  def self.up
    Err.where(:ido_id => nil).all do |err|
      err.update_attribute :ido_id, UUID.new.generate
    end
  end
end
