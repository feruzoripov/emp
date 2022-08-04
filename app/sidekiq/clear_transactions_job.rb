class ClearTransactionsJob
  include Sidekiq::Job

  def perform(*args)
    transactions = Transaction.where('created_at < ?', 1.hour.ago)
    puts '##########################################'
    puts '# Deleting transactions created 1 hour ago'
    puts "# Transactions count: #{transactions.size}"
    puts '##########################################'
    transactions.destroy_all
  end
end
