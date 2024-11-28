package project.domain;

import java.util.Objects;

/**
 * The Gps class represents geographical coordinates with latitude (coordX) and longitude (coordY).
 */
public class CoordenadasGps {
    /**
     * The latitude coordinate.
     */
    private Double latitude;
    /**
     * The longitude coordinate.
     */
    private Double longitude;

    private static final double EARTH_RADIUS = 6371;

    /**
     * Constructs a new Gps with the specified latitude and longitude coordinates.
     *
     * @param latitude The latitude coordinate.
     * @param longitude The longitude coordinate.
     */
    public CoordenadasGps(Double latitude, Double longitude) {
        this.latitude = latitude;
        this.longitude = longitude;
    }

    /**
     * Calculates the distance between two points taking into account the curvature of the earth.
     * @param coordenadasGps The instance with the coordinates passed as parameter
     * @return the distance between the gps of the parameter and the one that called the method
     */
    public double calculateDistance(CoordenadasGps coordenadasGps) {
        double lat1 = Math.toRadians(this.latitude);
        double lon1 = Math.toRadians(this.longitude);
        double lat2 = Math.toRadians(coordenadasGps.getLatitude());
        double lon2 = Math.toRadians(coordenadasGps.getLongitude());

        double dlat = lat2 - lat1;
        double dlon = lon2 - lon1;
        double a = Math.sin(dlat / 2) * Math.sin(dlat / 2)
                + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dlon / 2) * Math.sin(dlon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return EARTH_RADIUS * c;
    }

    /**
     * Get the latitude value of the GPS coordinates.
     *
     * @return The latitude value.
     */
    public Double getLatitude() {
        return latitude;
    }

    /**
     * Get the longitude value of the GPS coordinates.
     *
     * @return The longitude value.
     */
    public Double getLongitude() {
        return longitude;
    }

    /**
     * Returns a string representation of the GPS coordinates in the format "(latitude, longitude)".
     *
     * @return A string representation of the GPS coordinates.
     */
    @Override
    public String toString() {
        return "(" + latitude + ", " + longitude + ")";
    }

    /**
     * Indicates whether some other object is "equal to" this GPS object.
     *
     * @param o The reference object with which to compare.
     * @return true if this GPS object is the same as the o argument; false otherwise.
     */
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CoordenadasGps coordenadasGps = (CoordenadasGps) o;
        return Objects.equals(latitude, coordenadasGps.latitude) && Objects.equals(longitude, coordenadasGps.longitude);
    }

    /**
     * Returns a hash code value for the GPS coordinates.
     *
     * @return A hash code value based on the latitude and longitude.
     */
    @Override
    public int hashCode() {
        return Objects.hash(latitude, longitude);
    }

}

