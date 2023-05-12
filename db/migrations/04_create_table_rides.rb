Sequel.migration do
  change do
    create_table(:rides) do
      primary_key :id
      foreign_key :rider_id, :riders
      foreign_key :driver_id, :drivers
      DateTime :start_at, null: false
      DateTime :end_at
      Float :initial_latitude
      Float :initial_longitude
      Float :final_latitude
      Float :final_longitude
      String :transaction_id
      Integer :status, default: 0 #[:started, :finished, :charged]
    end
  end
end