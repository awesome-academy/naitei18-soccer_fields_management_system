class BookingMailer < ApplicationMailer
  def accept_unaccept booking, type
    @booking = booking

    mail to: booking.user.email,
         subject: t("mail.#{type}_booking"),
         template_path: "booking_mailer",
         template_name: type
  end
end
