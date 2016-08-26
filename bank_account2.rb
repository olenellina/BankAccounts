# Time is required to store the openDate attribute correctly (in case it's needed later)
require 'time'
require 'csv'

# The Bank module will hold four total classes: Account, CsvAccountProcessor, SavingsAccount & CheckingAccount
module Bank

  # The Account class has two responsiblites (setting up the Account objects and handling functions around balance)
  # Ideally, I might want to instead make two classes out of this: one for setting up Account objects and another for manipulating and tracking the account balance
  class Account
    # @@accounts is the class variable that will hold all instances of Account objects
    @@accounts = []
    # The balance attribute needs to be changed outside of the class, while ID does not
    attr_reader :id
    attr_accessor :balance

    # Setting up the Constructor for the Account class
    def initialize(id, balance, openDate)
      # Raising an ArgumentError that will exit the program and return a message if a new account is intialized with a negative opening balance
      unless balance.to_i >= 0
        raise ArgumentError.new("A new account cannot be created with initial negative balance.")
      end
      @id = id.to_i
      @balance = balance.to_i
      @openDate = Time.parse(openDate)
      # Adding a message, so I can ensure the accounts are created
      puts "Account ID #{id} has been created!"
      # Adding the current object (self) to the @@accounts array
      @@accounts << self
    end

    # Account method that will handle withdraw operations
    def withdraw(withdrawAmount)
      # This if statement will negate a withdraw if the user tries to withdraw more than the current account balance
      if withdrawAmount > @balance
        return @balance
      else
        @balance -= withdrawAmount
        return @balance
      end
    end

    # Account method that will handle deposit operations
    def deposit(depositAmount)
      # This if statement will ensure that a user does not try to enter a negative deposit (or a 0 deposit)
      if depositAmount <= 0
        return @balance
      else
        @balance += depositAmount
        return @balance
      end
    end

    # Account Class method that will handle returning all instances of Account objects, through the @@accounts Class variable
    def self.all
      return @@accounts
    end

    # Account Class method that will handle finding an Account object via the ID attribute passed in as a parameter
    def self.find(id)
      @@accounts.length.times do |x|
        if @@accounts[x].id == id
          return @@accounts[x]
        end
      end
    end
  end

  # The Account class only handles processing a .csv file to get the parameters required to pass to the Constructor for Account objects
  class CsvAccountProcessor
    def initialize(csvfile)
      # Creating an array to hold each line of the .csv file as an array object (it's an array of arrays, as each object is itself an array)
      accountArray = []
      counter = 0
      CSV.open(csvfile, "r").each do |line|
        accountArray[counter] = line
        counter += 1
      end

      # Creating new Account objects by passing in the required parameters by idexing into locations in the array where those parameters are stored
      accountArray.length.times do |x|
        Account.new(accountArray[x][0], accountArray[x][1], accountArray[x][2])
      end
    end
  end

    # The SavingsAccount class handles the operations for savings accounts that are unique to these objects, and not all Accounts
    class SavingsAccount < Account
      def initialize(id, balance, openDate)
        # Using super allows me to extend the Constructor for the Account class by adding in a raise ArgumentError check
        super
        # Raising an ArgumentError that will exit the program and return a message if a new account is intialized with a balance of less than $10.00
        unless balance.to_i > 10
          raise ArgumentError.new("A new account must have a minimum opening balance of $10.00.")
        end
      end

      def withdraw(withdrawAmount)
        # Super allows me to extend the withdraw method in the Account class
        # Adding functionality specific to savings accounts (transaction fee, maintaining minimum balance)
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

      # The add_interest method is unique to savings accounts and takes a new parameter of rate
      # It returns the interest accured and adds that number to the account's balance
      def add_interest(rate)
        interest = balance * rate/100
        @balance = balance + interest
        return interest
      end
    end

    # The CheckingAccount class handles the operations for checking accounts that are unique to these objects, and not all Accounts
    class CheckingAccount < Account
      def initialize(id, balance, openDate)
        # Super allows me to extend the Constructor in the Accounts class
        # Adding a new attribute to CheckingAccount objects, which will track the amount of free checks used for those accounts
        super
        @freechecks = 0
        @dayInMonth = 0
      end

      # This withdraw method extends the withdraw method in the Accounts class, for specific needs of CheckingAccount objects
      def withdraw(withdrawAmount)
        super
        # This extended functionality implements a $1.00 transaction fee for all withdraws on CheckingAccount objects
        # If that withdraw (plus the transaction fee) makes the balance negative, the whole transaction is voided (in a sense) and the balance is returned as the original balance
        @balance -= 1
        if balance < 0
          puts "Sorry, you cannot withdraw more than your account balance."
          @balance = balance + withdrawAmount + 1
          return @balance
        else
          return @balance
        end
      end

      # The withdraw_using_check method is unique to the CheckingAccount class but I would like to eventually try to reuse the code in withdraw (if possible)
      def withdraw_using_check(amount, dayInMonth)
        # Here I'm checking to see whether 3 free checks have already been used
        # If so, I then check to ensure that withdrawing the withdraw amount minus the check fee will not make the balance negative by more than $10.00
        if @freechecks >= 3 && dayInMonth <= 30

          if balance - amount - 2 >= -10
            @balance = balance - amount - 2
            @freechecks += 1
            return @balance
          else
            return @balance
          end

        elsif dayInMonth > 30
          reset_checks
          if balance - amount >= -10
            @balance = balance - amount
            @freechecks += 1
            return @balance
          else
            return @balance
          end

        elsif balance - amount >= -10
            @balance = balance - amount
            @freechecks += 1
            return @balance
        else
            return @balance
        end

      end

      # When called, the reset_checks method resets the free checks counter to 0 (the assumption is that this would be called each month)
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
puts myChecking.withdraw_using_check(8, 12)
puts myChecking.withdraw_using_check(8, 15)
puts myChecking.withdraw_using_check(8, 18)
puts myChecking.withdraw_using_check(8, 30)
puts myChecking.reset_checks
puts myChecking.withdraw_using_check(8, 12)
