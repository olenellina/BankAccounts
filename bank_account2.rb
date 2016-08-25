require 'time'
require 'csv'

module Bank

  class Account
    @@accounts = []
    attr_reader :balance, :id

    def initialize(id, balance, openDate)
      @id = id.to_i
      @balance = balance.to_i
      @openDate = Time.parse(openDate)
      unless balance.to_i >= 0
        raise ArgumentError.new("A new account cannot be created with initial negative balance")
      end
      @@accounts << self
      puts "Account ID #{id} has been created!"
    end

    def withdraw(withdrawAmount)
      newBalance = @balance - withdrawAmount
      if newBalance < 0
        puts "Sorry, you cannot have a negative balance. The most you can withdraw is $#{nicePrint(@balance)}."
        return @balance
      else
        @balance -= withdrawAmount
        puts "You have made a withdraw of $#{nicePrint(withdrawAmount)}. Your remaining balance is $#{nicePrint(@balance)}."
        return @balance
      end
    end

    def deposit(depositAmount)
      @balance += depositAmount
      puts "You have made a deposit of $#{nicePrint(depositAmount)}. Your new balance is $#{nicePrint(@balance)}."
      return @balance
    end

    def nicePrint(amount)
      return sprintf('%0.2f', amount.round(2))
    end

    def self.all
      return @@accounts
    end

    def self.find(id)
      @@accounts.length.times do |x|
        if @@accounts[x].id == id
          return @@accounts[x]
        end
      end
    end

  end
end

accountArray = []
counter = 0
CSV.open("accounts.csv", "r").each do |line|
  accountArray[counter] = line
  counter += 1
end

accountArray.length.times do |x|
  Bank::Account.new(accountArray[x][0], accountArray[x][1], accountArray[x][2])
end

Bank::Account.all[1].withdraw(20)
print Bank::Account.all
print Bank::Account.find(15155)
Bank::Account.all[1].deposit(20)
Bank::Account.all[1].withdraw(60)
