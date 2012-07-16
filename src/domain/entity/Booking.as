package domain.entity
{

	public interface Booking
	{

		function get customer() : Customer;

		function get room() : Room;

		function get checkInDate() : Date;

		function get checkOutDate() : Date;

	}
}
