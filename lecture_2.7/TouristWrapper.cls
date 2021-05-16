global class TouristWrapper {
    public List<Record> records;

    public class Record {
        public String name, birthday, email;
    }

    public static TouristWrapper parse(String jsonString) {
        return (TouristWrapper)JSON.deserialize(jsonString, TouristWrapper.class);
    }
}