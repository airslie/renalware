class FlatpickrWithTimeInput < FlatpickrInput
  def data_attributes
    {
      controller: "flatpickr",
      flatpickr_date_with_time_value: true
    }
  end
end
