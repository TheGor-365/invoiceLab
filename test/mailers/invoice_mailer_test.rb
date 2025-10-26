require "test_helper"

class InvoiceMailerTest < ActionMailer::TestCase
  test "created" do
    mail = InvoiceMailer.created
    assert_equal "Created", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "due_reminder" do
    mail = InvoiceMailer.due_reminder
    assert_equal "Due reminder", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "overdue_reminder" do
    mail = InvoiceMailer.overdue_reminder
    assert_equal "Overdue reminder", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "thank_you" do
    mail = InvoiceMailer.thank_you
    assert_equal "Thank you", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
