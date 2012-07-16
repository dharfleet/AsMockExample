package presentation
{
	import domain.entity.Booking;
	import domain.entity.Customer;
	import domain.entity.RoomType;
	import domain.service.Service;

	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	public class PresentationModel
	{

		public function PresentationModel(customer : Customer, service : Service)
		{
			this.customer = customer;
			this.service = service;
			this._bookings = new ArrayCollection();
		}

		public function get bookings() : IList
		{
			return _bookings;
		}


		public function makeBooking(checkInDate : Date, checkOutDate : Date, roomType : RoomType) : void
		{
			service.createBooking(_bookings, customer, checkInDate, checkOutDate, roomType);
		}


		private var customer : Customer;
		private var service : Service;

		private var _bookings : IList;
	}
}
