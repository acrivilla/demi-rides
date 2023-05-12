Sequel.migration do
  change do
    create_table(:payment_methods) do
      primary_key :id
      foreign_key :rider_id, :riders
      Integer :external_id, null: false
      String :token, null: false
      Integer :type, null: false, default: 0 ##0-card 1-nequi
    end
  end
end