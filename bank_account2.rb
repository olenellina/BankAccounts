require 'time'
require 'csv'

module Bank

  class Account
    @@accounts = []
    attr_reader :id
    attr_accessor :balance

    def initialize(id, balance, openDate)
      unless balance.to_i >= 0
        raise ArgumentError.new("A new account cannot be created with initial negative balance.")
      end
      @id = id.to_i
      @balance = balance.to_i
      @openDate = Time.parse(openDate)
      puts "Account ID #{id} has been created!"
      @@accounts << self
    end

    def withdraw(withdrawAmount)
      if withdrawAmount > @balance
        return @balance
      else
        @balance -= withdrawAmount
        return @balance
      end
    end

    def deposit(depositAmount)
      if depositAmount <= 0
        return @balance
      else
        @balance += depositAmount
        return @balance
      end
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

  class CsvAccountProcessor
    def initialize(csvfile)
      accountArray = []
      counter = 0
      CSV.open(csvfile, "r").each do |line|
        accountArray[counter] = line
        counter += 1
      end

      accountArray.length.times do |x|
        Account.new(accountArray[x][0], accountArray[x][1], accountArray[x][2])
      end
    end
  end

    class SavingsAccount < Account
      def initialize(id, balance, openDate)
        super
        unless balance.to_i > 10
          raise ArgumentError.new("A new account must have a minimum opening balance of $10.00.")
        end
      end

      def withdraw(withdrawAmount)
        super
        @balance -= 2
        if balance < 10
          puts "You must maintain a minimum balance of $10.00"
          @balance = balance + withdrawAmount + 2
          return balance
        else
          return balance
        end
      end

      def add_interest(rate)
        interest = balance * rate/100
        @balance = balance + interest
        return interest
      end
    end


    # #withdraw_using_check(amount): The input amount gets taken out of the account as a result of a check withdrawal. Returns the updated account balance.
    # Allows the account to go into overdraft up to -$10 but not any lower
    # The user is allowed three free check uses in one month, but any subsequent use adds a $2 transaction fee
    # #reset_checks: Resets the number of checks used to zero
    class CheckingAccount < Account
      def initialize(id, balance, openDate)
        super
        @freechecks = 0
      end

      def withdraw(withdrawAmount)
        super
        @balance -= 1
        if balance < 0
          puts "Sorry, you cannot withdraw more than your account balance."
          @balance = balance + withdrawAmount + 1
          return @balance
        else
          return @balance
        end
      end

      def withdraw_using_check(amount)
        if @freechecks >= 3
          if balance - amount - 2 >= -10
            @balance = balance - amount - 2
            @freechecks += 1
            return @balance
          else
            return @balance
          end
        else
          if balance - amount >= -10
            @balance = balance - amount
            @freechecks += 1
            return @balance
          else
            return @balance
          end
        end
      end

      def reset_checks
        @freechecks = 0
      end

    end

end

# Operations for Account Class (Waves 1 & 2)
# Bank::CsvAccountProcessor.new("accounts.csv")
# print Bank::Account.all
# Bank::Account.all[1].withdraw(20)
# print Bank::Account.find(15155)
# Bank::Account.all[1].deposit(-20)

# Operations for Savings Account Class (Wave 3)
# mySavings = Bank::SavingsAccount.new("1212", "20", "1999-03-27 11:30:09 -0800")
# puts mySavings.withdraw(10)
# puts mySavings.balance
# puts mySavings.add_interest(0.25)
# puts mySavings.balance

# Operations for Checking Account Class (Wave 3)
myChecking = Bank::CheckingAccount.new("1313", "200", "1999-03-27 11:30:09 -0800")
puts myChecking.balance
puts myChecking.withdraw_using_check(8)
puts myChecking.withdraw_using_check(8)
puts myChecking.withdraw_using_check(8)
puts myChecking.withdraw_using_check(8)
puts myChecking.reset_checks
puts myChecking.withdraw_using_check(8)
