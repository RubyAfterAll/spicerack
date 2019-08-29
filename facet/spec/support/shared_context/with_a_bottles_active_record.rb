# frozen_string_literal: true

RSpec.shared_context "with a bottles active record" do
  before(:all) do
    ActiveRecord::Base.connection.create_table :bottles do |t|
      t.boolean :broken, default: false
      t.timestamps
    end
  end

  after(:all) { ActiveRecord::Base.connection.drop_table :bottles }

  after { Bottle.destroy_all }
end
