RSpec.shared_examples "show flash not login" do
  it "show flash not login" do
    expect(flash[:danger]).to eq(I18n.t "flash.please_login")
  end
end

RSpec.shared_examples "redirect to login page" do
  it "redirect to login page" do
    expect(response).to redirect_to login_path
  end
end

RSpec.shared_examples "redirect to home page" do
  it "redirect to home page" do
    expect(response).to redirect_to root_path
  end
end

RSpec.shared_examples "show flash user not found" do
  it "show flash user not found" do
    expect(flash[:danger]).to eq(I18n.t "flash.user_not_found")
  end
end

RSpec.shared_examples "redirect to user page" do
  it "redirect to user page" do
    expect(response).to redirect_to user
  end
end

RSpec.shared_examples "should return the correct status code" do |status_code|
  it "return the correct status code" do
    expect(response).to have_http_status(status_code)
  end
end

RSpec.shared_examples "should return the correct message" do |message|
  it "should return the correct message" do
    expect_json(message: message)
  end
end
