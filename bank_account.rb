module Bank
  class Account
    attr_reader :balance, :id
    def initialize(id, name, address, balance)
      unless balance >= 0
        raise ArgumentError.new("A new account cannot be created with initial negative balance")
      end
      @id = id
      @balance = sprintf('%0.2f', balance.round(2))
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
