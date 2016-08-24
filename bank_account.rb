# Setting up the Bank module to contain the Account and Owner classes
module Bank

  # Account class will handle any functionality related to the bank accounts (withdraw, deposit, balance, etc.)
  class Account
    attr_reader :balance

    # Handles initializing new Account objects
    def initialize(id, name, address, balance)
      # Raising an ArgumentError, should a bank account be created with a negative balance
      unless balance >= 0
        raise ArgumentError.new("A new account cannot be created with initial negative balance")
      end
      @id = id
      @balance = balance.to_f
      puts "Account ID #{id} has been created!"
      # Creating a new Owner object that is associated with the account that was just initialized
      # In addition to name & address, id is passed to the new Owner object so that a message can be displayed
      @owner = Owner.new(id, name, address)
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

  # Owner class will contain data related to the owner of the associated Account object
  class Owner
    # Not currently using :name or :address outside of this class yet but can see the need for it later, so setting up attr_reader
    attr_reader :name, :address
    def initialize(id, name, address)
      @name = name
      @address = address
      puts "The owner of Account ID #{id} is #{@name}"
    end
  end
end

# The below tests to ensure that the ArgumentError is raised for an account with an opening negative balance
# myAccount = Bank::Account.new(123, -40)

# Creating a new Bank::Account object with required parameters
myAccount = Bank::Account.new(123, "Melissa Rodriguez", "Kirkland, WA", 40)

# Testing Account class operations
myAccount.withdraw(20)
myAccount.deposit(20)
myAccount.withdraw(60)
