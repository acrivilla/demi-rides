Sequel.migration do
  change do
    create_table(:drivers) do
      primary_key :id
      String :name, null: false
      Integer :status, default: 0 ##[:free, :busy]
    end
  end
end