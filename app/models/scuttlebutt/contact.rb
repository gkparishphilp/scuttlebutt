module Scuttlebutt
	class Contact < Scuttlebutt::Message
		include Scuttlebutt::ContactSearchable if (Scuttlebutt::ContactSearchable rescue nil)
	end
end
