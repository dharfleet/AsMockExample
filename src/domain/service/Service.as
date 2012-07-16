package domain.service
{
	import domain.entity.Booking;
	import domain.entity.Customer;
	import domain.entity.RoomType;

	import mx.collections.IList;

	public interface Service
	{

		function createBooking(customer : Customer, checkInDate : Date, checkOutDate : Date, roomType : RoomType) : Booking;

	}
}
