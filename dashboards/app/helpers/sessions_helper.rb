module SessionsHelper

  def sign_in(account)
    session[:account_id] = account.id
    session[:permission] = 0
  end
  
  def sign_out()
    session.delete(:account_id)
    session.delete(:permission)
  end
  
  def current_account()
    @current_account ||= Account.find_by(id: session[:account_id])
  end

  def account_signed_in?
    !current_account.nil?
  end

  def has_permission?
    session[:permission]
  end

end