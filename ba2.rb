# Optional:
#
# Create an Owner class which will store information about those who own the Accounts.
#   This should have info like name and address and any other identifying information that an account owner would have.
# Add an owner property to each Account to track information about who owns the account.
#   The Account can be created with an owner, OR you can create a method that will add the owner after the Account has already been created.


module Bank
  class Account
    attr_reader :balance, :id
    def initialize(id, name, address, balance)
      unless balance >= 0
        raise ArgumentError.new("A new account cannot be created with initial negative balance")
      end
      @id = id
      @balance = balance
      @owner = Owner.new(id, name, address)
    end

    def withdraw(withdrawAmount)
      newBalance = @balance - withdrawAmount
      if newBalance < 0
        puts "Sorry, you cannot have a negative balance"
        return @balance
      else
        @balance -= withdrawAmount
        return @balance
      end
    end

    def deposit(depositAmount)
      @balance += depositAmount
      return @balance
    end
  end

  class Owner

    attr_reader :name, :address
    def initialize(id, name, address)
      @name = name
      @address = address
      puts "The owner of account ID #{id} is #{@name}"
    end
  end
end


# myAccount = Bank::Account.new(123, 40)
# myAccount = Bank::Account.new(123, -40)
myAccount = Bank::Account.new(123, "Mel", "Seattle", 40)


myAccount.withdraw(20)
puts myAccount.balance
myAccount.deposit(20)
puts myAccount.balance
myAccount.withdraw(60)
puts myAccount.balance
