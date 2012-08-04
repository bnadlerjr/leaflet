Sequel.migration do
  change do
    create_table(:books) do
      primary_key :id
      String :title, :null => false
      String :description, :null => false, :test => true
      Float :price, :null => false, :default => 0.0
      String :status, :null => false, :default => 'active'
    end
  end
end