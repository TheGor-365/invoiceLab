module Invoices
  class NumberGenerator
    # Format: INV-YYYYMM-XXXX (per user)
    def self.next_for(user_id:)
      date_part = Date.current.strftime("%Y%m")
      prefix = "INV-#{date_part}-"
      last = Invoice.where(user_id: user_id)
                    .where("number LIKE ?", "#{prefix}%")
                    .order(number: :desc)
                    .limit(1)
                    .pick(:number)

      seq = last ? last.split("-").last.to_i + 1 : 1
      "#{prefix}#{seq.to_s.rjust(4, '0')}"
    end
  end
end
