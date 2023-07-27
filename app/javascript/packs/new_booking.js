$('#booking_date_booking').blur(function () {
  booking_date = $("#booking_date_booking").val()
  football_pitch_id = $("#booking_football_pitch_id").val()
  $.ajax({
    url: `/football_pitches/${football_pitch_id}/time_booked_booking`,
    method: 'GET',
    data: `date_booking=${booking_date}`,
    dataType: "json"
  }).done(function(data) {
    time_booked_booking = data.join(", ");
    $("#time_booked_booking").html(data.length ? `${I18n.t("javascript.can_not_booking_coincide_with_these_times")} ${time_booked_booking}` : I18n.t("javascript.can_booking_any_time"));
  });
});

$('#booking_end_time').blur(function () {
  price_per_hour =  parseInt($("#price_per_hour").val());
  start_time = $("#booking_start_time").val().split(":")[0];
  end_time = $("#booking_end_time").val().split(":")[0];
  if (start_time < end_time) {
    hour = parseInt(end_time, 10) - parseInt(start_time, 10);
    total_cost = hour * price_per_hour;
    $("#booking_total_cost").val(total_cost);
  }
});
