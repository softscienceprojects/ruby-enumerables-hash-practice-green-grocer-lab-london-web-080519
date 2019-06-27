def consolidate_cart(cart)
  # makeObj = Hash[cart.collect {|v| [v] }]
  #try to push again?
  result = {}
  cart.each do |food| #for each of the food items in the cart
    if result[food.keys[0]] #check and see if our new cart has the food already
      result[food.keys[0]][:count] += 1 #if it does, then update the count
    else #start by creating a new cart from the existing cart
     result[food.keys[0]] = { #new cart 'result' will take values from cart
       :price=> food.values[0][:price], #add the cart details to our result one by one
       :clearance=> food.values[0][:clearance],
       :count=> 1, #and add your new value 'count'
     }
  end
end
  result #return updated cart
end

def apply_coupons(cart, coupons)
  # for each of the coupons we receive
  coupons.each do |coupon|
        #check if the cart has an item that we have a coupon for
        if cart.keys.include? coupon[:item]
          # (ADV) then, if the cart's item count is greater than or equal to the num the coupon is available for
          if cart[coupon[:item]][:count] >= coupon[:num]
            # create your new line #{ITEM} W/COUPON
            my_coupon = "#{coupon[:item]} W/COUPON"
            # if my new my_coupon exists in the cart
              if cart[my_coupon]
                 # then create a 'count' attribute that copies over the coupon's num
                 cart[my_coupon][:count] += coupon[:num]
              else
                cart[my_coupon] = {  #adding my coupon to the cart
                  :price => coupon[:cost]/coupon[:num], #each of the individual coupons
                  :clearance => cart[coupon[:item]][:clearance], #coupons don't have clearance. Check for the coupon's item in the cart :clearance
                  :count => coupon[:num],
                }
              end
            # now we're subtracting the coupon from the cart
            cart[coupon[:item]][:count] = cart[coupon[:item]][:count] - coupon[:num]
        end
      end
  end
cart
end

def apply_clearance(cart)
  # discount the price of every item on clearance by 20%
  #look up all the items in our cart
  cart.each do |food, values|
    # and see if they have the value "clearance == true"
    if values[:clearance] == true
      #returns the cart with updated prices (use .round(2))
      values[:price] = (values[:price] * 0.8).round(2)
    end
  end
cart
end

def checkout(cart, coupons)
  total = 0
  # consolidate the cart array into a hash
  my_checkout = consolidate_cart(cart)

  #apply discounts if proper number of items are present
  my_coupons = apply_coupons(my_checkout, coupons)

  #apply discount if items are on clearance
  my_clearance = apply_clearance(my_coupons)
  #use the updated figures with the coupons applied

  my_clearance.keys.each do |food| #use your final amount. for each of the keys (which is the name of the food, e.g. beer or beer w/coupon)
    puts "Price: #{my_clearance[food][:price]}. Count: #{my_clearance[food][:count]}"
    #the total gets updated with the price of the food *'s how many the count is you are buying
    total += my_clearance[food][:price]*my_clearance[food][:count]
    puts total
    # total = total + values[:price]
  end


  if total > 100
    total = (total * 0.9).round(2)
  # if cart's total is over 100, customer gets additional 10% off
  end
  total
end
