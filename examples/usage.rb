require 'uri'
require_relative '../lib/plain_params'

class ContactParams < PlainParams
  @real_fields = %i[name email phone]
  @virtual_fields = %i[formatted_phone email_domain]

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, format: { with: /\A\d{10,11}\z/ }

  def formatted_phone
    return unless phone
    if phone.length == 11
      "(#{phone[0..1]}) #{phone[2..6]}-#{phone[7..10]}"
    else
      "(#{phone[0..1]}) #{phone[2..5]}-#{phone[6..9]}"
    end
  end

  def email_domain
    email.split('@').last if email
  end
end

puts "=== Valid Contact ==="
contact = ContactParams.new(
  name: "Alice Smith",
  email: "alice@example.com",
  phone: "11987654321"
)

if contact.valid?
  puts "Name: #{contact.name}"
  puts "Email: #{contact.email}"
  puts "Phone: #{contact.phone}"
  puts "Formatted Phone: #{contact.formatted_phone}"
  puts "Email Domain: #{contact.email_domain}"
  puts "\nAll values:"
  p contact.values
else
  puts "Errors: #{contact.errors.full_messages.join(', ')}"
end

puts "\n=== Invalid Contact ==="
invalid_contact = ContactParams.new(
  name: "Bob",
  email: "invalid-email",
  phone: "123"
)

if invalid_contact.valid?
  puts "Valid!"
else
  puts "Errors: #{invalid_contact.errors.full_messages.join(', ')}"
end 