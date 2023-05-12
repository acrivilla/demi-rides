Sequel.migration do
  change do
    create_table(:riders) do
      primary_key :id
      String :name, null: false
      String :email, null: false
    end
  end
end