module Bank
  class Account
    attr_reader :balance, :id
    def initialize(id, name, address, balance)
      unless balance >= 0
        raise ArgumentError.new("A new account cannot be created with initial negative balance")
      end
      @id = id
      @balance = balance.to_f
      puts "Account ID #{id} has been created!"
      @owner = Owner.new(id, name, address)
    end

    def withdraw(withdrawAmount)
      newBalance = @balance - withdrawAmount
      if newBalance < 0
        puts "Sorry, you cannot have a negative balance. The most you can withdraw is $#{nicePrint(@balance)}."
        return @balance
      else
        @balance -= withdrawAmount
        puts "You have made a withdraw of $#{withdrawAmount.to_f}. Your remaining balance is $#{nicePrint(@balance)}."
        return @balance
      end
    end

    def deposit(depositAmount)
      @balance += depositAmount
      puts "You have made a deposit of $#{depositAmount.to_f}. Your new balance is $#{nicePrint(@balance)}."
      return @balance
    end

    # the NicePrint method will return balance formatted as money.
    def nicePrint(balance)
      return sprintf('%0.2f', balance.round(2))
    end
  end

  class Owner
    attr_reader :name, :address
    def initialize(id, name, address)
      @name = name
      @address = address
      puts "The owner of Account ID #{id} is #{@name}"
    end
  end
end

# myAccount = Bank::Account.new(123, 40)
# myAccount = Bank::Account.new(123, -40)
myAccount = Bank::Account.new(123, "Melissa Rodriguez", "Kirkland, WA", 40)


myAccount.withdraw(20)
myAccount.deposit(20)
myAccount.withdraw(60)
