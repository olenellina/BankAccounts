# Requirements
#
# Update the Account class to be able to handle all of these fields from the CSV file used as input.
# For example, manually choose the data from the first line of the CSV file and ensure you can create a new instance of your Account using that data
# Add the following class methods to your existing Account class
# self.all - returns a collection of Account instances, representing all of the Accounts described in the CSV. See below for the CSV file specifications
# self.find(id) - returns an instance of Account where the value of the id field in the CSV matches the passed parameter
# CSV Data File
#
# Bank::Account
#
# The data, in order in the CSV, consists of:
# ID - (Fixnum) a unique identifier for that Account
# Balance - (Fixnum) the account balance amount, in cents (i.e., 150 would be $1.50)
# OpenDate - (Datetime) when the account was opened

require 'csv'

# Setting up the Bank module to contain the Account and Owner classes
module Bank

  # Account class will handle any functionality related to the bank accounts (withdraw, deposit, balance, etc.)
  class Account
    @@acounts
    attr_reader :balance

    # Handles initializing new Account objects
    def initialize(id, balance, openDate)
      # Raising an ArgumentError, should a bank account be created with a negative balance
      unless balance.to_i >= 0
        raise ArgumentError.new("A new account cannot be created with initial negative balance")
      end
      @id = id.to_i
      @balance = balance.to_i
      @openDate = openDate
      puts "Account ID #{id} has been created!"
      # Creating a new Owner object that is associated with the account that was just initialized
      # In addition to name & address, id is passed to the new Owner object so that a message can be displayed
    end

    # Handles withdraw operations on the account
    def withdraw(withdrawAmount)
      # Creating a new variable, so that I don't have to change balance unless the withdraw amount is acceptable
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

    # Handles deposit operations on the account
    def deposit(depositAmount)
      @balance += depositAmount
      puts "You have made a deposit of $#{nicePrint(depositAmount)}. Your new balance is $#{nicePrint(@balance)}."
      return @balance
    end

    # Handles returning the account balance or transaction amount formatted as two decimal places (rounded)
    def nicePrint(amount)
      return sprintf('%0.2f', amount.round(2))
    end
  end

    def csvAccounts(csvfile)
      accountsArray = []
      counter = 0

      CSV.open(csvfile, "r").each do |line|
        accountsArray[counter] = line
        counter += 1
      end

      accountsArray.length.times do |x|
        @@acounts << Bank::Account.new(accountsArray[x][0], accountsArray[x][1], accountsArray[x][2])
      end
    end

  end
end


Bank:Account.csvAccounts("accounts.csv")

# Testing Account class operations
newAccounts[0].withdraw(20)
newAccounts[0].deposit(20)
newAccounts[0].withdraw(60)
