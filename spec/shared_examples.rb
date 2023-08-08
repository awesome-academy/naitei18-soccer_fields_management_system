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
